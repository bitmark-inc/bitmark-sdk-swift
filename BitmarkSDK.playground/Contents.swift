//: Playground - noun: a place where people can play

import XCPlayground
import BitmarkSDK
import TweetNacl

XCPSetExecutionShouldContinueIndefinitely()

let fileURL = Bundle.main.url(forResource: "test", withExtension: ".txt")!

do {
    BitmarkSDK.initialize(config: SDKConfig(apiToken: "bmk-lljpzkhqdkzmblhg", network: .testnet, urlSession: URLSession.shared))
    let account = try Account(version: .v2, network: .livenet)
    let seed1 = try account.toSeed()
    let recovery = try account.getRecoverPhrase(language: .chineseTranditional)
    print(seed1)
    print(recovery)
    
    let account2 = try Account(recoverPhrase: recovery, language: .chineseTranditional)
    print(try account2.toSeed())
}
catch let e {
    print(e)
}

