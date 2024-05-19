# enim
This is a web enumeration tool made with nim.

## Compile
- Install nim
- nim c -d:release -d:strip --opt:size enim.nim

## Usage

### Flags:
- --wordlist, 	-w
- --url,			-u
- --exclude-code, -c
- --extensions,	-x

### Example:
`./enim -u=http://localhost:8080/ -w=/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -c=500 -x=html,php` 
