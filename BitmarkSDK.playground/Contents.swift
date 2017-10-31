//: Playground - noun: a place where people can play

import XCPlayground
import BitmarkSDK
import TweetNacl

XCPSetExecutionShouldContinueIndefinitely()

let fileURL = Bundle.main.url(forResource: "test", withExtension: ".txt")!

do {
    let account = try Account(fromSeed: "5XEECttxvRBzxzAmuV4oh6T1FcQu4mBg8eWd9wKbf8hweXsfwtJ8sfH")
    account.accountNumber.string
    let data = try Data(contentsOf: fileURL)
    
    
    
//    IssueHelper.doIssue(fromURL: fileURL, name: "Anh test", metadata: ["Name": "Hello world"], account: account, completion: { (success, txs) in
//        print(success)
//        print(txs)
//    })
    
    account.issueBitmarks(assetFile: fileURL, propertyName: "Just test", completion: { (success, txs) in
        print(success)
        print(txs)
        
        if let txs = txs {
            for tx in txs {
                if let bitmarkId = tx {
                    account.transferBitmark(bitmarkId: bitmarkId, toAccount: "eZpG6Wi9SQvpDatEP7QGrx6nvzwd6s6R8DgMKgDbDY1R5bjzb9", completion: { (success) in
                        print(success)
                    })
                }
            }
        }
    })
    
}
catch let e {
    print(e)
    
}

