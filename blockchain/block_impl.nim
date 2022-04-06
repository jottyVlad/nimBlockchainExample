import nimSHA2, std/[strutils]

type
    Block* = object
        index*: int
        timestamp*: string
        status*: int
        hash*: string
        prevHash*: string
        proof*: int64
    
proc calculateHash*(blockchain_block: var Block) : string = 
    var sha: SHA256
    sha.initSHA()
    var hash_string = $blockchain_block.index & 
                        blockchain_block.timestamp &
                        $blockchain_block.status &
                        blockchain_block.prev_hash &
                        $blockchain_block.proof
    sha.update(hash_string)
    let digest = sha.final()
    let hash = digest.hex()

    return toLower(hash)

proc isBlockValid*(oldBlock: var Block, newBlock: var Block) : (bool, string) = 
    if oldBlock.index + 1 != newBlock.index: return (false, "index")
    if oldBlock.hash != newBlock.prevHash: return (false, "hash with prev")
    if newBlock.calculateHash() != newBlock.hash: return (false, "hash")
    return (true, "")
