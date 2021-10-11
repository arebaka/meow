#!/bin/bash

VERSION="0.2"




error() {
	echo $1 >&2
	exit $2
}

usage() {
	cat >&2 <<EOF
Usage: $0 [options...] [<method>] <URL>
Type $0 --help for more information
EOF

	exit 1
}

help() {
	cat <<EOF
meow v$VERSION
An easy tool for making requests using cURL and following redirects

Usage:
  $0 [options...] <method> <URL>
  $0 [options...] <URI>

When the request can have a body (methods POST, PUT, DELETE, PATCH), then it is read from stdin.
When a successful response has a body, then it is written to stdout.
If the response cannot has a body (methods HEAD, PUT, TRACE), then its headers is written to stdout.
If cURL returns a non-zero exit code, its output is written to stderr without changes.
Methods can be specified in any case (post, POST, POsT, etc).

Allowed methods:
  get (defalut)
  head
  post
  put
  delete
  connect
  options
  trace
  patch

Options:
  -a, --useragent   "<useragent>"    - set a user-agent for the request
  -c, --cookie      "<cookie>"       - set a cookie for the request
  -C, --save-cookie <filename>       - save a cookie from the response to the file
  -h, --header      "<key>: <value>" - set a optional header for the request
  -H, --get-headers                  - get response headers instead of body
  -p, --proxy       <proxy>          - use the proxy
  -r, --referrer    <referrer>       - set an address making the request
  -t, --type        <type>           - set a type of the sending content
  -v, --version                      - show a version of the tool
EOF

	exit 0
}

request() {
	local method=$1
	local url=$2
	local useragent=${3:-"meow v$VERSION by arelive (https://are.moe)"}
	local cookie=$4
	local save_cookie=$5
	local proxy=$6
	local referrer=$7
	local type=${8:-"application/octet-stream"}
	local get_headers=$9
	local headers=""

	for h in ${10}
	do headers="$headers -H $h"
	done

	case $method in
		POST|PUT|DELETE|PATCH)
			curl -sSL -X $method \
				-A "$useragent" \
				-H "Cached-Control: no-cache" \
				-H "Content-Type: $type" \
				$([ -n "$cookie" ] && cat<<<"-b $cookie") \
				$([ -n "$save_cookie" ] && cat<<<"-c $save_cookie") \
				$([ -n "$proxy" ] && cat<<<"-x $proxy") \
				$([ -n "$referrer" ] && cat<<<"-e $referrer") \
				$([ -n "$get_headers" ] && cat<<<"-I") \
				$headers \
				--data-binary @- "$url"
		;;
		GET|HEAD|CONNECT|OPTIONS|TRACE)
			curl -sSL -X $method \
				-A "$useragent" \
				-H "Cached-Control: no-cache" \
				$([ -n "$cookie" ] && cat<<<"-b $cookie") \
				$([ -n "$save_cookie" ] && cat<<<"-c $save_cookie") \
				$([ -n "$proxy" ] && cat<<<"-x $proxy") \
				$([ -n "$referrer" ] && cat<<<"-e $referrer") \
				$([ -n "$get_headers" ] && cat<<<"-I") \
				$headers \
				"$url"
		;;
		*)
			error "The method $method not allowed!" 1
		;;
	esac

	exit $?
}




posargs=()
headers=()

while [ $# -gt 0 ]
do
	case $1 in
		--help)
			help
		;;
		-v|--version)
			echo $VERSION
			exit 0
		;;
		-a|--useragent|-c|--cookie|-C|--save-cookie|-h|--header|-p|--proxy|-r|--referrer|-t|--type)
			[ $# -lt 2 ] && error "The option -$1 requires a parameter!" 1

			case $1 in
				-a|--useragent)    useragent=$2   ;;
				-c|--cookie)       cookie=$2      ;;
				-C|--save-cookie)  save_cookie=$2 ;;
				-h|--header)       headers+=($2)  ;;
				-p|--proxy)        proxy=$2       ;;
				-r|--referrer)     referrer=$2    ;;
				-t|--type)         type=$2        ;;
			esac

			shift; shift
		;;
		-H|--get-headers)
			get_headers=1
			shift
		;;
		*)
			posargs+=($1)
			shift
		;;
	esac
done

if [ ${#posargs[@]} -eq 2 ]
then
	method=${posargs[0]}
	url=${posargs[1]}
elif [ ${#posargs[@]} -eq 1 ]
then
	method=GET
	url=${posargs[0]}
else
	usage
fi




request ${method^^} "$url" "$useragent" "$cookie" "$save_cookie" "$proxy" "$referrer" "$type" "$get_headers" "${headers[*]}"
