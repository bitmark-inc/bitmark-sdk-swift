//: Playground - noun: a place where people can play

import XCPlayground
import BitmarkSDK
import CryptoSwift
import TweetNacl

XCPSetExecutionShouldContinueIndefinitely()

let fileURL = Bundle.main.url(forResource: "test", withExtension: ".txt")!

do {
    let account = try Account()
    let seed1 = try account.toSeed()
    let recoveryPhrase = try account.getRecoverPhrase()
    
    let account2 = try Account(fromSeed: seed1)
    let recoveryPhrase2 = try account2.getRecoverPhrase()
}
catch let e {
    print(e)
}

