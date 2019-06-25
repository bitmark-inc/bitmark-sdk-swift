//
//  EventSubscription.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 6/13/19.
//  Copyright © 2019 Bitmark. All rights reserved.
//

import Foundation
import SwiftCentrifuge

public struct BitmarkChangedInfo {
    public let bitmarkId: String
    public let txId: String
    public let presence: Bool
}

extension BitmarkChangedInfo: Decodable {
    enum CodingKeys: String, CodingKey
    {
        case bitmarkId = "bitmark_id"
        case txId = "tx_id"
        case presence = "presence"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bitmarkId = try values.decode(String.self, forKey: .bitmarkId)
        txId = try values.decode(String.self, forKey: .txId)
        presence = try values.decode(Bool.self, forKey: .presence)
    }
}



public class EventSubscription {
    public static let shared = EventSubscription()
    internal var client: CentrifugeClient?
    internal var account: String?
    
    public func connect(_ signable: KeypairSignable) throws {
        let api = API()
        let token = try api.requestWSToken(signable: signable)
        
         // Thus we've successfully connected to the api, api endpoint must be valid
        let endpointHost = api.endpoint.apiServerURL.host!
        
        let wsEndpoint = "wss://subscription." + endpointHost + "/connection/websocket?format=protobuf"
        let config = CentrifugeClientConfig()
        self.client = CentrifugeClient(url: wsEndpoint, config: config)
        self.client?.setToken(token)
        self.client?.connect()
        self.account = signable.address
    }
    
    public func disconnect() {
        self.client?.disconnect()
    }
    
    public func listenNewBlock(handler: @escaping (Int) -> Void) throws {
        guard let client = self.client else {
            throw("Not connected")
        }
        
        let sub = try client.newSubscription(channel: "blockchain:new-block",
                                   delegate: NewBlockSubscription(handler: handler))
        sub.subscribe()
    }
    
    public func listenBitmarkChanged(handler: @escaping (BitmarkChangedInfo) -> Void) throws {
        guard let client = self.client,
         let account = self.account else {
            throw("Not connected")
        }
        
        let sub = try client.newSubscription(channel: "bitmark_changed:\(account)",
                                             delegate: BitmarkChangedSubscription(handler: handler))
        sub.subscribe()
    }
    
    public func listenTransferOffer(handler: @escaping (String) -> Void) throws {
        guard let client = self.client,
            let account = self.account else {
                throw("Not connected")
        }
        
        let sub = try client.newSubscription(channel: "tx_offer#\(account)",
                                             delegate: TransferOfferSubscription(handler: handler))
        sub.subscribe()
    }
}

private class NewBlockSubscription: CentrifugeSubscriptionDelegate {
    typealias T = (Int) -> Void
    let handler: T
    init(handler: @escaping T) {
        self.handler = handler
    }
    
    func onPublish(_ sub: CentrifugeSubscription, _ event: CentrifugePublishEvent) {
        do {
            let data = try JSONDecoder().decode([String:Int].self, from: event.data)
            guard let blockNumber = data["block_number"] else {
                throw("Invalid format")
            }
            self.handler(blockNumber)
        }
        catch let e {
            globalConfig.logger.log(level: .error, message: e.localizedDescription)
        }
    }
}

private class BitmarkChangedSubscription: CentrifugeSubscriptionDelegate {
    typealias T = (BitmarkChangedInfo) -> Void
    let handler: T
    init(handler: @escaping T) {
        self.handler = handler
    }
    
    func onPublish(_ sub: CentrifugeSubscription, _ event: CentrifugePublishEvent) {
        do {
            let data = try JSONDecoder().decode(BitmarkChangedInfo.self, from: event.data)
            self.handler(data)
        }
        catch let e {
            globalConfig.logger.log(level: .error, message: e.localizedDescription)
        }
    }
}

private class TransferOfferSubscription: CentrifugeSubscriptionDelegate {
    typealias T = (String) -> Void
    let handler: T
    init(handler: @escaping T) {
        self.handler = handler
    }
    
    func onPublish(_ sub: CentrifugeSubscription, _ event: CentrifugePublishEvent) {
        do {
            let data = try JSONDecoder().decode([String:String].self, from: event.data)
            guard let blockNumber = data["bitmark_id"] else {
                throw("Invalid format")
            }
            self.handler(blockNumber)
        }
        catch let e {
            globalConfig.logger.log(level: .error, message: e.localizedDescription)
        }
    }
}
