# meow
*meow!*
> An easy tool for making requests using cURL and following redirects

![](https://img.shields.io/tokei/lines/github/arebaka/meow)
![](https://img.shields.io/github/repo-size/arebaka/meow)
![](https://img.shields.io/codefactor/grade/github/arebaka/meow)

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
- `-H, --head`                         – get response head instead of body
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

## Shortcuts
Some invalid mime values of the type specified with the -t flag
are automatically converted to valid shorthand commands.
If the conversion fails, they remain as they are.

| shortcut | replacement |
| --- | --- |
| cmd | text/cmd |
| css | text/css |
| csv | text/csv |
| html | text/html |
| javascript | text/javascript |
| text | text/plain |
| php | text/php |
| markdown | text/markdown |
| cache-manifest | text/cache-manifest |
| atom | application/atom+xml |
| EDI-X12 | application/EDI-X12 |
| EDIFACT | application/EDIFACT |
| json | application/json |
| octet-stream | application/octet-stream |
| pdf | application/pdf |
| postscript | application/postscript |
| ps | application/postscript |
| soap | application/soap+xml |
| woff | application/font-woff |
| xhtml | application/xhtml+xml |
| dtd | application/xml-dtd |
| xop | application/xop+xml |
| bittorrent | application/x-bittorrent |
| tex | application/x-tex |
| xml | application/xml |
| acc | audio/acc |
| mp3 | audio/mpeg |
| vorbis | audio/vorbis |
| gif | image/gif |
| jpeg | image/jpeg |
| pjpeg | image/pjpeg |
| png | image/png |
| svg | image/svg+xml |
| tiff | image/tiff |
| webp | image/webp |
| iges | model/iges |
| mesh | model/mesh |
| vrml | model/vrml |
| form-data | multipart/form-data |
| quicktime | video/quicktime |
| webm | video/webm |
| .css | text/css |
| .csv | text/csv |
| .html | text/html |
| .htm | text/html |
| .js | text/javascript |
| .text | text/plain |
| .txt | text/plain |
| .php | text/php |
| .md | text/markdown |
| .json | application/json |
| .pdf | application/pdf |
| .ps | application/postscript |
| .woff | application/font-woff |
| .xhtml | application/xhtml+xml |
| .dtd | application/xml-dtd |
| .zip | application/zip |
| .gzip | application/gzip |
| .tex | application/x-tex |
| .xml | application/xml |
| .acc | audio/acc |
| .mp3 | audio/mpeg |
| .ogg | audio/vorbis |
| .gif | image/gif |
| .jpeg | image/jpeg |
| .jpg | image/jpeg |
| .pjpeg | image/pjpeg |
| .pjpg | image/pjpeg |
| .png | image/png |
| .svg | image/svg+xml |
| .tiff | image/tiff |
| .tif | image/tiff |
| .webp | image/webp |
| .iges | model/iges |
| .igs | model/iges |
| .mesh | model/mesh |
| .mp4 | video/mp4 |
| .qtff | video/quicktime |
| .webm | video/webm |
