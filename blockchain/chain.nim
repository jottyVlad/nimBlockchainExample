import block_impl, utils, std/times

type
    Chain* = object
        blocks*: seq[Block]

proc mineBlock(blockObj: var Block, difficulty: int) : Block = 
    var maxNonce = 9_223_372_036_854_775_807
    var nonce : int64 = 0

    var rightStr = "0"*difficulty
    echo "Mining block for status: " & $blockObj.status
    while nonce < maxNonce:
        blockObj.proof = nonce
        var hash = blockObj.calculateHash()
        echo substr(hash, 0, difficulty-1)
        if substr(hash, 0, difficulty-1) != rightStr:
            nonce += 1
        else:
            blockObj.hash = hash
            return blockObj

proc getLatestBlock*(blockchain: var Chain) : Block = 
    return blockchain.blocks[blockchain.blocks.len() - 1]

proc generateBlock*(blockchain: var Chain, status: int) : Block = 
    var time = $now().toTime().toUnixFloat()
    var index = blockchain.getLatestBlock().index + 1
    var prevHash = blockchain.getLatestBlock().hash

    var newBlock = Block(index: index, 
                        timestamp: time, 
                        status: status, 
                        hash: "",
                        prevHash: prevHash,
                        proof: 0)
    newBlock = newBlock.mineBlock(3)
    blockchain.blocks.add(newBlock)
    return newBlock

proc generateInitBlock*(status: int) : Block = 
    var time = now().format("yyyy/MM/dd/hh/mm/ss")
    var index = 0
    var prevHash = "0"

    var newBlock = Block(index: index, 
                        timestamp: time, 
                        status: status, 
                        hash: "",
                        prevHash: prevHash,
                        proof: 0)
    
    newBlock.hash = newBlock.calculateHash()
    return newBlock

proc initChain*(status: int) : Chain = 
    var chain = Chain()
    var genesisBlock = generateInitBlock(status)

    chain.blocks.add(genesisBlock)
    return chain

proc isChainValid*(chain: var Chain) : bool = 
    for i in 1..chain.blocks.len - 1:
        var currentBlock = chain.blocks[i]
        var prevBlock = chain.blocks[i-1]
        if currentBlock.prevHash != prevBlock.hash: return false
        if currentBlock.hash != currentBlock.calculateHash(): return false
        if prevBlock.hash != prevBlock.calculateHash(): return false
    
    return true