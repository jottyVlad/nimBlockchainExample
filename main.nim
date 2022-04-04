import jester, strutils, asyncdispatch, json, std/jsonutils, blockchain

var chain = initChain(0)

proc replaceChain*(newBlocks: Chain) = 
    if newBlocks.blocks.len > chain.blocks.len:
        chain = newBlocks

proc generateResponse(ch: Chain) : string = 
    var response = "";
    for t in ch.blocks:
        response = response & $t.toJson & "<br />"

    return response


router mainRouter:
    get "/":
        resp(generateResponse(chain))

    get "/create/@status":
        var newBlock : Block = generateBlock(chain.blocks[chain.blocks.len - 1], parseInt(@"status"))
        if isBlockValid(chain.blocks[chain.blocks.len - 1], newBlock):
            chain.blocks.add(newBlock)
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