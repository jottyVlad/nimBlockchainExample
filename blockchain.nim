import nimSHA2, std/times
from strutils import intToStr

type
    Block* = ref object of RootObj
        index: int
        timestamp: string
        status: int
        hash: string
        prevHash: string

proc generateHash(blockchain_block: Block) : string = 
    var sha: SHA256
    sha.initSHA()
    var hash_string = intToStr(blockchain_block.index) & 
                                blockchain_block.timestamp &
                                intToStr(blockchain_block.status) &
                                blockchain_block.prev_hash
    sha.update(hash_string)
    let digest = sha.final()
    let hash = digest.hex()
    return hash

proc generateBlock*(blockchain_block: Block, status: int) : Block = 
    var time = now().format("yyyy-MM-dd-hh-mm-ss")
    var index = blockchain_block.index + 1
    var prevHash = blockchain_block.hash

    var newBlock = Block(index: index, 
                        timestamp: time, 
                        status: status, 
                        hash: "",
                        prevHash: prevHash)
    newBlock.hash = generateHash(newBlock)
    return newBlock

proc generateInitBlock*(status: int) : Block = 
    var time = now().format("yyyy-MM-dd-hh-mm-ss")
    var index = 0
    var prevHash = ""

    var newBlock = Block(index: index, 
                        timestamp: time, 
                        status: status, 
                        hash: "",
                        prevHash: prevHash)
    
    newBlock.hash = generateHash(newBlock)
    return newBlock

proc isBlockValid*(oldBlock: Block, newBlock: Block) : bool = 
    if oldBlock.index + 1 != newBlock.index: return false
    if oldBlock.hash != newBlock.prevHash: return false
    if generateHash(newBlock) != newBlock.hash: return false
    return true