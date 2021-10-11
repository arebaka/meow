# meow v0.2
*meow!*

> An easy tool for making requests using cURL and following redirects

## Usage
`meow [options...] <method> <URL>`
or
`meow [options...] <URL>`

When the request can have a body (methods POST, PUT, DELETE, PATCH), then it is read from stdin.  
When a successful response has a body, then it is written to stdout.  
If the response cannot has a body (methods HEAD, PUT, TRACE), then its headers is written to stdout.  
If cURL returns a non-zero exit code, its output is written to stderr without changes.  
Methods can be specified in any case (post, POST, POsT, etc).

## Allowed methods
- get (defalut)
- head
- post
- put
- delete
- connect
- options
- trace
- patch

## Options
- `-a, --useragent   "<useragent>"`    – set a user-agent for the request
- `-c, --cookie      "<cookie>"`       – set a cookie for the request (can be a filename)
- `-C, --save-cookie <filename>`       – save a cookie from the response to the file
- `-h, --header      "<key>: <value>"` – set a optional header for the request
- `-H, --get-headers`                  – get response headers instead of body
- `-p, --proxy       <proxy>`          – use the proxy
- `-r, --referrer    <referrer>`       – set an address making the request
- `-t, --type        <type>`           – set a MIME-type of the sending content
- `-v, --version`                      – show a version of the tool

## Install
Just copy the `meow.sh` file to `/usr/bin/meow`

## Example
```bash
$ BASE=https://sode.su
$ meow get $BASE/@arelive/profile > test
$ cat test && echo  # echo for newline
{"id":287228005,"username":"arelive","searchable":true,"friendable":"public","invitable":"protected","name":"Arelive","type":"user","cover":null,"avatar":"1313402292021605115.png","links":[]}
$ meow $BASE/@0/profile && echo  # with redirect
{"id":0,"username":"anon","searchable":false,"friendable":"private","invitable":"private","name":"","type":"user","cover":null,"avatar":null,"links":[]}
$ meow post $BASE/api/me <<<'' && echo  # unusable without auth
{"status":2}
$ COOKIE="lang=rus; userid=287228005 session=$SECRET_KEY"  # auth
$ cat > data <<<'{"name": "Arelive, the creator of meow console utility"}'
$ meow post -c "$COOKIE" -t application/json $BASE/api/set.profile < data && echo
{"status":0}
# Now the name of profile changed
$ meow -H head $BASE/undefined  # trying to get headers from unresolvable path
HTTP/2 404 
server: Desu
date: Thu, 30 Sep 2021 10:11:08 GMT
content-type: text/html; charset=utf-8
content-length: 3253
content-security-policy: default-src 'self' oauth.telegram.org;style-src 'self';script-src 'self' 'unsafe-eval' telegram.org;base-uri 'self';block-all-mixed-content;font-src 'self' https: data:;frame-ancestors 'self';img-src 'self' data:;object-src 'none';script-src-attr 'none';upgrade-insecure-requests
x-dns-prefetch-control: off
expect-ct: max-age=0
x-frame-options: SAMEORIGIN
strict-transport-security: max-age=15552000; includeSubDomains
x-download-options: noopen
x-content-type-options: nosniff
x-permitted-cross-domain-policies: none
referrer-policy: no-referrer
x-xss-protection: 0
cache-control: public, max-age: 0
etag: W/"cb5-iFGpwk3mDfL0gTfn+GMUM6pwYDg"
vary: Accept-Encoding
```
