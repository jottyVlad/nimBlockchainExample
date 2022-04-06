import jester, strutils, asyncdispatch, json, std/jsonutils, blockchain/[block_impl, chain]

var chainObj = initChain(0)

proc replaceChain*(newBlocks: Chain) = 
    if newBlocks.blocks.len > chainObj.blocks.len:
        chainObj = newBlocks

proc generateResponse(ch: Chain) : string = 
    var response = "";
    for t in ch.blocks:
        response = response & $t.toJson & "<br />"

    return response


router mainRouter:
    get "/":
        resp(generateResponse(chainObj))

    get "/create/@status":
        var latestBlock = chainObj.getLatestBlock()
        var newBlock : Block = generateBlock(chainObj, parseInt(@"status"))
        var validTuple = isBlockValid(latestBlock, newBlock)
        if validTuple[0]:
            resp(%newBlock)
        else:
            resp("There is an error corrupted <br />" & validTuple[1])

proc main() =
    let port = Port(2857)
    let settings = newSettings(port=port)
    var jester = initJester(mainRouter, settings=settings)
    jester.serve()

when isMainModule:
  main()