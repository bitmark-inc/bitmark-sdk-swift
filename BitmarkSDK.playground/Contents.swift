//: Playground - noun: a place where people can play

import XCPlayground
import BitmarkSDK
import CryptoSwift
import TweetNacl

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
//XCPSetExecutionShouldContinueIndefinitely()

func executionTimeInterval(block: () -> ()) -> CFTimeInterval {
    let start = CACurrentMediaTime()
    block();
    let end = CACurrentMediaTime()
    return end - start
}

func roundTo16(n: Int) -> Int {
    return 16 * ((n + 15) / 16)
}

func paddingData(data: Data) -> Data {
    var result = Data(count: roundTo16(n: data.count))
    result.replaceSubrange(0..<data.count, with: data)
    return result
}

let fileURL = Bundle.main.url(forResource: "test", withExtension: ".txt")!

do {
    let data = try Data(contentsOf: fileURL)
    let e1 = executionTimeInterval {
        let sha1 = SHA3Compute.computeSHA3(data: data)
    }
    
    let e2 = executionTimeInterval {
        let sha2 = SHA3Compute.computeWithCryptoSwift(data: data)
    }
    //    let accountA = try Account(fromSeed: "5XEECttxvRBzxzAmuV4oh6T1FcQu4mBg8eWd9wKbf8hweXsfwtJ8sfH")
//    let accountB = try Account(fromSeed: "5XEECt6Mhj8Tanb9CDTGHhTQ7RqbS5LHD383LRK6QGDuj8mwfUU6gKs")
//    try accountA.toSeed().count
//    try accountB.registerPublicEncryptionKey(completion: { (success) in
//        print(success)
//    })

//    let accessibility = Accessibility.publicAsset
//    let propertyName = "Test Bitmark SDK" // the name of the asset to be registered on the blockchain
//    let propertyMetadata = ["author": "Anh Nguyen"] // the metadata of the asset to be registered on the blockchain
//    let quantity = 2 // the amount of bitmarks to be issued
    
//    let result = try accountA.issueBitmarks(assetFile: fileURL, accessibility: accessibility, propertyName: propertyName, propertyMetadata: propertyMetadata, quantity: quantity)
//    print(result!.0.map(({ (issue) -> String in
//        return issue.txId!
//    })))
//    ["814013b19de56699ebe0aaf9fd301637a1af467828e25df8c1c811bff4436ade", "dc646d42a382f6b014e8aa396250dfefafa7cc61d0db9231af17b21dd80cf3e4"]
    
//    let signOffer = try accountA.createTransferOffer(bitmarkId: "814013b19de56699ebe0aaf9fd301637a1af467828e25df8c1c811bff4436ade", recipient: accountB.accountNumber.string)
//    print(signOffer!)

    // ======================= Encrypt with session key: daa538069499aab138563cdf3a3cd5ccd6a746696b7dfdba86ea00fcc2ece125

//    accountA.issueBitmarks(assetFile: fileURL,
//                          accessibility: accessibility,
//                          propertyName: propertyName,
//                          propertyMetadata: propertyMetadata,
//                          quantity: quantity, completion: { (success, bitmarkIds) in
//        print(success)
//    })
    
//    let bitmarkID = "3879de7df441003c5387a0c727c133d647f2415901313c9afa33d1cf0fc40fb6"
//    accountA.transferBitmark(bitmarkId: bitmarkID,
//                             toAccount: accountB.accountNumber.string,
//                             completion: { (success) in
//        print(success)
//    })
//
//    accountA.downloadAsset(bitmarkId: bitmarkID, completion: { (data) in
//        print(data?.hexEncodedString)
//    })
//    Encrypt message: ad2cebc0ff006ee60705a2cba362ec5d36947a03ffeff5854c64d8dd92ed856c
//    {"status": "OK"}
//    [{"txId":"f2b6a0414978cf068f9894174cc9f3a0fb01e4efa1ea0f1a2130c7fe8c701955"}]
//    true

//    let result = try accountA.transferBitmark(bitmarkId: "b4a1dd1cff268483db396016aa255330a91b922b96958a7059b5749fa92d21b0", toAccount: accountB.accountNumber.string)
    
    
//    let key = "daa538069499aab138563cdf3a3cd5ccd6a746696b7dfdba86ea00fcc2ece125".hexDecodedData
//    let nonce = Data(repeating: 0x00, count: 12)
//
//    let plainText = "610a".hexDecodedData
//
//    let cipheraaa = try Chacha20Poly1305.seal(withKey: key, nonce: nonce, plainText: plainText, additionalData: nil)
    
//    let aData = Data()
//
//    let chacha20 = try ChaCha20(key: key.bytes, iv: iv.bytes)
//    let tagKey = try chacha20.encrypt([UInt8](repeating: 0x00, count: 64))[0..<32]
//    print(Data(bytes: Array(tagKey)).hexEncodedString)
//    let cipherText = try chacha20.encrypt(plainText.bytes)
//    let cipher = Data(bytes: cipherText)
//
//    var aDataCount = aData.count.littleEndian
//    let aDataData = Data(bytes: &aDataCount, count: MemoryLayout.size(ofValue: aDataCount))
//
//    var cipherCount = cipher.count.littleEndian
//    let cipherData = Data(bytes: &cipherCount, count: MemoryLayout.size(ofValue: cipherCount))
//
//    let tagInput = paddingData(data: aData) + paddingData(data: cipher) + aDataData + cipherData
//    let poly = Poly1305(key: Array(tagKey))
//    let tag = try poly.authenticate(tagInput.bytes)
//
//    print("tag input =" + tagInput.hexEncodedString)
//
//    let encrypted = Data(bytes: cipherText) + Data(bytes: tag)
//    let encryptedText = cipheraaa.hexEncodedString
//    let decyptedText = try Chacha20Poly1305.open(withKey: key, nonce: nonce, cipherText: cipheraaa, additionalData: nil)
//    print(decyptedText.hexEncodedString)
    
//    try accountA.issueThenTransfer(assetFile: fileURL, accessibility: accessibility, propertyName: propertyName, propertyMetadata: propertyMetadata, toAccount: "fDyVczbiJstgno27j5VTy4UKHz1q5XEWUsQXFzimwkm7tiQ5ug")
}
catch let e {
    print(e)
}

