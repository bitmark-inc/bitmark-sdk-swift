//: Playground - noun: a place where people can play

import XCPlayground
import BitmarkSDK
import TweetNacl

XCPSetExecutionShouldContinueIndefinitely()

let fileURL = Bundle.main.url(forResource: "test", withExtension: ".txt")!

do {
    BitmarkSDK.initialize(config: SDKConfig(apiToken: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjk0NTQ1MDg5NzcsImlhdCI6MTU2NTMyNDk3NywiaXNzIjoiOVEvSllhVkJJOXZmRlp6N0J2VjRNdz09Iiwic3ViIjoiZVhjcHlKcXpxZGdWVk1YRVJMUmh2dEpxWGFWWnZoS0hkcEZLSzdlUnJ4UDlSTXM4cFYifQ.EiIXik49k-DTuRIRYK5nPm6qV9viZupYqlfLxr5n-3wkkABW55InRXnPWHlyDE0Fx0b1gcJg67eifVSNgnKrD6l2JdKEzDBvUfmj41OQxFTJ_hwA25wfYHudnwD_-axtv3LqREYu_jkxNKe6riw3IcX-ve3zvpDnFqA_Ntu75Z10-Hapkz9yhAVI_pp0CKo2qjKNjYB2s21PvQ2r2yifvt_xLTXth-aw61VzRKJfr1mmi97yHoay6Fo89sDmQpxaSxHRTKq2thyGWghXVz49iQozkthMwpMZZ5i9cSyAvr5a-wOcmI8-NZbKNv9RfBwd4bNm_hZFcXSfw_ZaLwmNNw", network: .testnet, urlSession: URLSession.shared))
    
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

