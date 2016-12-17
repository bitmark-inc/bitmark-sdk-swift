//
//  Config.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/16/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import Foundation

struct ed25519 {
    let name = "ed25519"
    let value = 0x01
    let publicLength = 32
    let privateLength = 64
    let seedLength = 32
}

struct part {
    let privateKey = 0x00
    let publicKey = 0x01
}

struct Server {
    let name: String
    let addressValue: Int
    let kifValue: Int
    let staticHostName: String
    let staticNodes: [String]
}

let liveNet = Server(name: "livenet",
                     addressValue: 0x00,
                     kifValue: 0x00,
                     staticHostName: "nodes.live.bitmark.com",
                     staticNodes: ["118.163.122.206:3130", "118.163.122.207:3130"])

let testNet = Server(name: "testnet",
                     addressValue: 0x01,
                     kifValue: 0x01,
                     staticHostName: "nodes.test.bitmark.com",
                     staticNodes: ["118.163.120.178:3566", "118.163.120.176:3130"])
