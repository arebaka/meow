#!/bin/bash

VERSION='0.3'




declare -A shortcut_types

shortcut_types[cmd]='text/cmd'
shortcut_types[css]='text/css'
shortcut_types[csv]='text/csv'
shortcut_types[html]='text/html'
shortcut_types[javascript]='text/javascript'
shortcut_types[text]='text/plain'
shortcut_types[php]='text/php'
shortcut_types[markdown]='text/markdown'
shortcut_types[cache-manifest]='text/cache-manifest'
shortcut_types[atom]='application/atom+xml'
shortcut_types[EDI-X12]='application/EDI-X12'
shortcut_types[EDIFACT]='application/EDIFACT'
shortcut_types[json]='application/json'
shortcut_types[octet-stream]='application/octet-stream'
shortcut_types[pdf]='application/pdf'
shortcut_types[postscript]='application/postscript'
shortcut_types[ps]='application/postscript'
shortcut_types[soap]='application/soap+xml'
shortcut_types[woff]='application/font-woff'
shortcut_types[xhtml]='application/xhtml+xml'
shortcut_types[dtd]='application/xml-dtd'
shortcut_types[xop]='application/xop+xml'
shortcut_types[bittorrent]='application/x-bittorrent'
shortcut_types[tex]='application/x-tex'
shortcut_types[xml]='application/xml'
shortcut_types[acc]='audio/acc'
shortcut_types[mp3]='audio/mpeg'
shortcut_types[vorbis]='audio/vorbis'
shortcut_types[gif]='image/gif'
shortcut_types[jpeg]='image/jpeg'
shortcut_types[pjpeg]='image/pjpeg'
shortcut_types[png]='image/png'
shortcut_types[svg]='image/svg+xml'
shortcut_types[tiff]='image/tiff'
shortcut_types[webp]='image/webp'
shortcut_types[iges]='model/iges'
shortcut_types[mesh]='model/mesh'
shortcut_types[vrml]='model/vrml'
shortcut_types[form-data]='multipart/form-data'
shortcut_types[quicktime]='video/quicktime'
shortcut_types[webm]='video/webm'

shortcut_types[.css]='text/css'
shortcut_types[.csv]='text/csv'
shortcut_types[.html]='text/html'
shortcut_types[.htm]='text/html'
shortcut_types[.js]='text/javascript'
shortcut_types[.text]='text/plain'
shortcut_types[.txt]='text/plain'
shortcut_types[.php]='text/php'
shortcut_types[.md]='text/markdown'
shortcut_types[.json]='application/json'
shortcut_types[.pdf]='application/pdf'
shortcut_types[.ps]='application/postscript'
shortcut_types[.woff]='application/font-woff'
shortcut_types[.xhtml]='application/xhtml+xml'
shortcut_types[.dtd]='application/xml-dtd'
shortcut_types[.zip]='application/zip'
shortcut_types[.gzip]='application/gzip'
shortcut_types[.tex]='application/x-tex'
shortcut_types[.xml]='application/xml'
shortcut_types[.acc]='audio/acc'
shortcut_types[.mp3]='audio/mpeg'
shortcut_types[.ogg]='audio/vorbis'
shortcut_types[.gif]='image/gif'
shortcut_types[.jpeg]='image/jpeg'
shortcut_types[.jpg]='image/jpeg'
shortcut_types[.pjpeg]='image/pjpeg'
shortcut_types[.pjpg]='image/pjpeg'
shortcut_types[.png]='image/png'
shortcut_types[.svg]='image/svg+xml'
shortcut_types[.tiff]='image/tiff'
shortcut_types[.tif]='image/tiff'
shortcut_types[.webp]='image/webp'
shortcut_types[.iges]='model/iges'
shortcut_types[.igs]='model/iges'
shortcut_types[.mesh]='model/mesh'
shortcut_types[.mp4]='video/mp4'
shortcut_types[.qtff]='video/quicktime'
shortcut_types[.webm]='video/webm'




error() {
	echo $2 >&2
	exit $1
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
  -H, --head                         - get response head instead of body
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
	local useragent=${3:-"meow v$VERSION"}
	local cookie=$4
	local save_cookie=$5
	local proxy=$6
	local referrer=$7
	local type=$8
	local get_head=$9
	local headers=()
	local options=()

	[ -n "${shortcut_types[$type]}" ] && type="${shortcut_types[$type]}"
	[ -z "$type" ] && type='application/octet-stream'

	[ -n "$cookie" ]      && options+=(--cookie "$cookie")
	[ -n "$save_cookie" ] && options+=(--cookie-jar "$save_cookie")
	[ -n "$proxy" ]       && options+=(--proxy "$proxy")
	[ -n "$referrer" ]    && options+=(--referer "$referrer")
	[ -n "$get_head" ]    && options+=(--head)

	for h in "${10}"
	do headers+=(--header "$h")
	done

	case $method in
		POST|PUT|DELETE|PATCH)
			curl -sSL -X $method \
				-A "$useragent" \
				-H "Cached-Control: no-cache" \
				-H "Content-Type: $type" \
				"${options[@]}" \
				"${headers[@]}" \
				--data-binary @- "$url"
		;;
		GET|HEAD|CONNECT|OPTIONS|TRACE)
			curl -sSL -X $method \
				-A "$useragent" \
				"${options[@]}" \
				"${headers[@]}" \
				"$url"
		;;
		*)
			error 1 "The method $method not allowed!"
		;;
	esac

	exit $?
}




posargs=()
headers=()

while [ $# -gt 0 ]
do
	case $1 in
		'-?'|--help)
			help
		;;
		-v|--version)
			echo $VERSION
			exit 0
		;;
		-a|--useragent|-c|--cookie|-C|--save-cookie|-h|--header|-p|--proxy|-r|--referrer|-t|--type)
			[ $# -lt 2 ] && error 1 "The option -$1 requires a parameter!"

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
		-H|--head)
			get_head=1
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




request ${method^^} "$url" "$useragent" "$cookie" "$save_cookie" "$proxy" "$referrer" "$type" "$get_head" "${headers[*]}"
