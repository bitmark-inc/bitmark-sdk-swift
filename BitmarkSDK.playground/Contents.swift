//: Playground - noun: a place where people can play

import XCPlayground
import BitmarkSDK
import TweetNaclSwift

XCPSetExecutionShouldContinueIndefinitely()

//let seed = try Seed(fromBase58: "5XEECsKPsXJEZRQJfeRU75tEk72WMs87jW1x9MhT6jF3UxMVaAZ7TSi")
let seed = try Seed(version: 1, network: Network.testnet)
let backup = seed.base58String
let resore = try Seed(fromBase58: backup)


let seedCombine = seed.base58String
let network = seed.network.name
let core = seed.core.hexEncodedString

let seed1 = try Seed(version: 1, network: Network.livenet)
let seed2 = try Seed(fromBase58: seed1.base58String)

let randomData = Common.randomBytes(length: 32)!
let fingerPrint1 = FileUtil.Fingerprint.computeFingerprint(data: randomData)

let fileURL = Bundle.main.url(forResource: "test", withExtension: ".txt")!
let sessionKey = Common.randomBytes(length: 32)!

do {
    let secretKey = try TweetNaclSwift.NaclSign.KeyPair.keyPair()
    let fingerPrint2 = try FileUtil.Fingerprint.computeFingerprint(fromFile: fileURL)
    let encryption = try FileUtil.Encryption.encryptFile(fromFile: fileURL, sessionKey: sessionKey, secretKey: secretKey.secretKey)
}
catch let e {
    print(e)
}

let issueNonce = UInt64(1475482198529)

do {
    let seedCore = Common.randomBytes(length: 32)!
    let authKey = try AuthKey(fromKeyPair: seedCore, network: Network.livenet, type: KeyType.ed25519)
//    let authKey = try AuthKey(fromKIF: "dvSQZidUCWm179wQZFPWm1GxpWqmhw6eTov72dQRDEqwoyJhWZ")
    print(authKey.kif)
    var asset = Asset()
    try asset.set(name: "Just want to test it")
    try asset.set(metadata: ["description": "this is description"])
    try asset.set(fingerPrint: "w3845723904723094asdasd7238942234")
    try asset.sign(withPrivateKey: authKey)

    var issue = Issue()
    issue.set(asset: asset)
    issue.set(nonce: issueNonce)
    try issue.sign(privateKey: authKey)

//    try Gateway.doIssue(withData: issue, network: Config.testNet, responseHandler: { (result) in
//        print(result)
//    })
    
    let transferTo = try AccountNumber(address: "fL3jywNn8T2hJa6EV7Gm1bR7MAQx4rFtMD8RtayYnvturtJvC7")
//    let transferTo = AccountNumber(fromPubKey: "73346e71883a09c0421e5d6caa473239c4438af71953295ad903fea410cabb44".hexDecodedData, network: Network.testnet, keyType: KeyType.ed25519)
    
    var transfer = Transfer()
    try transfer.set(from: "c5be32754022c7b4075ec7c8524935a4b6bbdd6e4db451259d1a4dd19a8321a3")
    try transfer.set(to: transferTo)
    try transfer.sign(privateKey: authKey)
    
    try Gateway.doTransfer(withData: transfer, network: Network.testnet, responseHandler: { (result, error) in
        print(result)
    })
}
catch let e {
    print(e)
}
