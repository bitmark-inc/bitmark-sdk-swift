//: Playground - noun: a place where people can play

import XCPlayground
import BitmarkSDK
import TweetNacl

XCPSetExecutionShouldContinueIndefinitely()

let fileURL = Bundle.main.url(forResource: "test", withExtension: ".txt")!

do {
    BitmarkSDK.initialize(config: SDKConfig(apiToken: "bmk-lljpzkhqdkzmblhg", network: .testnet, urlSession: URLSession.shared))
    
    let phrase = ["abuse", "tooth", "riot", "whale", "dance", "dawn", "armor", "patch", "tube", "sugar", "edit", "clean",
                  "guilt", "person", "lake", "height", "tilt", "wall", "prosper", "episode", "produce", "spy", "artist", "account"]
    
    let (account, bitmarkids) = try Migration.migrate(recoverPhrase: phrase, language: .english)
    print(account.accountNumber)
    print(try account.getRecoverPhrase(language: .english))
    print(bitmarkids)
}
catch let e {
    print(e)
}

