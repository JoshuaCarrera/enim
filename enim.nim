import std/httpclient # Para crear un cliente http

from strformat import fmt # Para formatear los textos
import strutils # Para el split

import std/os # Para obtener el string de los parametros desde la terminal
from parseopt import getopt # Para manipular los parametros desde la terminal

var 
    url: string
    wordlist: string
    ignoreCode = @["404"] 
    extensions = @[""]
    entries: int
    client = newHttpClient()

proc countWordlist(wordlist: string): int =
    for line in lines(wordlist): result.inc

proc showScope() =
    echo fmt"""
url:        {url}
wordlist:   {wordlist}
ignoreCode: {ignoreCode}
extensions: {extensions}

entries: {entries}
"""

proc setParams(params: seq[string]) =
    for kind, key, val in getopt(params):
        case kind
        of cmdArgument:
            discard
        of cmdLongOption, cmdShortOption:
            case key
            of "wordlist", "w": wordlist = val
            of "url", "u": url = val
            of "exclude-code", "c":
                for code in val.split(","):
                    ignoreCode.add(code)
            of "extensions", "x":
                for ext in val.split(","):
                    extensions.add("."&ext)
                    entries = countWordlist(wordlist)*len(extensions)# Total
            of "out", "o":
                discard
        of cmdEnd: assert(false)

proc enumerate() =
    try:
        var tries: int = 0 
        for line in lines(wordlist):
            for ext in extensions:
                if line != "": # Bastante mejorable
                    if not(line[0] == '#'): # Verifica si no es un comentario
                        client = newHttpClient(maxRedirects=0)
                        var response = client.get(url&line&ext)
                        if not (response.status[0..2] in ignoreCode):
                            echo fmt"/{line&ext} (Status: {response.status}) [Size: {len(response.body)}]"
                        client.close()
    finally:
        client.close()

setParams(commandLineParams())
showScope()
enumerate()
