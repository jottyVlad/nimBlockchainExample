import nimSHA2, std/[times, strutils]

type
    Block* = ref object of RootObj
        index: int
        timestamp: string
        status: int
        hash: string
        prevHash: string

    Chain* = ref object of RootObj
        blocks*: seq[Block]


proc calculateHash(blockchain_block: var Block) : string = 
    var sha: SHA256
    sha.initSHA()
    var hash_string = intToStr(blockchain_block.index) & 
                                blockchain_block.timestamp &
                                intToStr(blockchain_block.status) &
                                blockchain_block.prev_hash
    sha.update(hash_string)
    let digest = sha.final()
    let hash = digest.hex()

    return toLower(hash)


proc isBlockValid*(oldBlock: var Block, newBlock: var Block) : bool = 
    if oldBlock.index + 1 != newBlock.index: return false
    if oldBlock.hash != newBlock.prevHash: return false
    if newBlock.calculateHash() != newBlock.hash: return false
    return true

proc generateBlock*(blockchain_block: var Block, status: int) : Block = 
    var time = now().format("yyyy-MM-dd-hh-mm-ss")
    var index = blockchain_block.index + 1
    var prevHash = blockchain_block.hash

    var newBlock = Block(index: index, 
                        timestamp: time, 
                        status: status, 
                        hash: "",
                        prevHash: prevHash)
    newBlock.hash = calculateHash(newBlock)
    return newBlock

proc generateInitBlock*(status: int) : Block = 
    var time = now().format("yyyy-MM-dd-hh-mm-ss")
    var index = 0
    var prevHash = "0"

    var newBlock = Block(index: index, 
                        timestamp: time, 
                        status: status, 
                        hash: "",
                        prevHash: prevHash)
    
    newBlock.hash = calculateHash(newBlock)
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