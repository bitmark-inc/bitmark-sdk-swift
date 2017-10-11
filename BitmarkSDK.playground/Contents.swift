//: Playground - noun: a place where people can play

import BitmarkSDK
import TweetNaclSwift

let seed = try Seed(fromBase58: "5XEECsKPsXJEZRQJfeRU75tEk72WMs87jW1x9MhT6jF3UxMVaAZ7TSi")
let seedCombine = seed.base58String
let network = seed.network.name
let core = seed.core.hexEncodedString

let seed1 = try Seed(version: 1, network: Config.liveNet)
let seed2 = try Seed(fromBase58: seed1.base58String)

let randomData = Common.randomBytes(length: 32)!
let fingerPrint1 = FileUtil.Fingerprint.computeFingerprint(data: randomData)

let fileURL = Bundle.main.url(forResource: "test", withExtension: ".txt")!
let sessionKey = Common.randomBytes(length: 32)!

do {
    let secretKey = try TweetNaclSwift.NaclSign.KeyPair.keyPair()
    let fingerPrint2 = try FileUtil.Fingerprint.computeFingerprint(fromFile: fileURL)
    let encryption = try FileUtil.Encryption.encryptFile(fromFile: fileURL, sessionKey: sessionKey, secretKey: secretKey.secretKey)
    print(encryption.hexEncodedString)
}
catch let e {
    print(e)
}
