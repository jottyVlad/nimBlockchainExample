import jester, strutils, asyncdispatch, json, std/jsonutils, blockchain

let firstBlock = generateInitBlock(251)    
var blocks : seq[Block]
blocks.add(firstBlock)


proc generateResponse() : string = 
    var response = "";
    for t in blocks:
        response = response & $t.toJson
        response = response & "<br />"

    return response


router mainRouter:
    get "/":
        resp(generateResponse())

    get "/create/@status":
        var newBlock : Block = generateBlock(blocks[blocks.len - 1], parseInt(@"status"))
        if isBlockValid(blocks[blocks.len - 1], newBlock):
            blocks.add(newBlock)
            resp(%newBlock)
        else:
            resp("There is an error corrupted")

proc main() =
  let port = Port(2857)
  let settings = newSettings(port=port)
  var jester = initJester(mainRouter, settings=settings)
  jester.serve()

when isMainModule:
  main()