//: Playground - noun: a place where people can play

import XCPlayground
import BitmarkSDK
import TweetNacl

XCPSetExecutionShouldContinueIndefinitely()

let fileURL = Bundle.main.url(forResource: "test", withExtension: ".txt")!

do {
    let accountA = try Account(fromSeed: "5XEECttxvRBzxzAmuV4oh6T1FcQu4mBg8eWd9wKbf8hweXsfwtJ8sfH")
    let accountB = try Account(fromSeed: "5XEECt6Mhj8Tanb9CDTGHhTQ7RqbS5LHD383LRK6QGDuj8mwfUU6gKs")

    let accessibility = Accessibility.publicAsset
    let propertyName = "bitmark swift sdk demo" // the name of the asset to be registered on the blockchain
    let propertyMetadata = ["author": "Bitmark Inc. developers"] // the metadata of the asset to be registered on the blockchain
    let quantity = 1 // the amount of bitmarks to be issued

    accountA.issueBitmarks(assetFile: fileURL,
                          accessibility: accessibility,
                          propertyName: propertyName,
                          propertyMetadata: propertyMetadata,
                          quantity: quantity, completion: { (success, bitmarkIds) in
        print(success)
        print(bitmarkIds)
    })
    
    let bitmarkID = "3879de7df441003c5387a0c727c133d647f2415901313c9afa33d1cf0fc40fb6"
    accountA.transferBitmark(bitmarkId: bitmarkID,
                             toAccount: accountB.accountNumber.string,
                             completion: { (success) in
        print(success)
    })
    
    accountA.downloadAsset(bitmarkId: bitmarkID, completion: { (data) in
        print(data?.hexEncodedString)
    })
}
catch let e {
    print(e)
}

