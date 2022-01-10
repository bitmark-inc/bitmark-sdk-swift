//
//  API+Transfer.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 10/31/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation

extension API {
    struct TransferResponse: Codable {
        let txid: String
    }
    
    struct ReplyResponse: Codable {
        let txid: String?
    }
    
    internal func transfer(_ transfer: TransferParams) throws -> String {
        let json = try JSONSerialization.data(withJSONObject: transfer.toJSON(), options: [])
        
        let requestURL = endpoint.apiServerURL.appendingPathComponent("/v5/transfer")
        
        var urlRequest = URLRequest(url: requestURL, cachePolicy: .reloadIgnoringCacheData)
        urlRequest.httpBody = json
        urlRequest.httpMethod = "POST"
        
        let (data, _) = try urlSession.synchronousDataTask(with: urlRequest)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        let transferResponse = try decoder.decode(TransferResponse.self, from: data)
        return transferResponse.txid
    }
    
    internal func transfer(withCounterTransfer counterTransfer: CountersignedTransferRequest) throws -> String {
        let json = try JSONSerialization.data(withJSONObject: ["transfer": counterTransfer.toJSON()], options: [])
        
        let requestURL = endpoint.apiServerURL.appendingPathComponent("/v5/transfer")
        
        var urlRequest = URLRequest(url: requestURL, cachePolicy: .reloadIgnoringCacheData)
        urlRequest.httpBody = json
        urlRequest.httpMethod = "POST"
        
        let (data, _) = try urlSession.synchronousDataTask(with: urlRequest)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        let transferResponse = try decoder.decode(TransferResponse.self, from: data)
        return transferResponse.txid
    }
    
    internal func offer(_ offer: OfferParams) throws {
        let json = try JSONSerialization.data(withJSONObject: offer.toJSON(), options: [])
        
        let requestURL = endpoint.apiServerURL.appendingPathComponent("/v5/transfer")
        
        var urlRequest = URLRequest(url: requestURL, cachePolicy: .reloadIgnoringCacheData)
        urlRequest.httpBody = json
        urlRequest.httpMethod = "POST"
        
        _ = try urlSession.synchronousDataTask(with: urlRequest)
    }
    
    internal func respond(_ offerResponse: OfferResponseParams) throws -> String? {
        let json = try JSONSerialization.data(withJSONObject: offerResponse.toJSON(), options: [])
        
        let requestURL = endpoint.apiServerURL.appendingPathComponent("/v5/transfer")
        
        var urlRequest = URLRequest(url: requestURL, cachePolicy: .reloadIgnoringCacheData)
        urlRequest.httpBody = json
        urlRequest.httpMethod = "PATCH"
        for (k, v) in offerResponse.apiHeader! {
            urlRequest.setValue(v, forHTTPHeaderField: k)
        }
        
        let (data, _) = try urlSession.synchronousDataTask(with: urlRequest)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        let response = try decoder.decode(ReplyResponse.self, from: data)
        return response.txid
    }
}

extension API {
    struct TransactionQueryResponse: Codable {
        let tx: Transaction
        let asset: Asset?
    }
    
    struct TransactionsQueryResponse: Codable {
        let txs: [Transaction]
        let assets: [Asset]?
        let blocks: [Block]?
    }
    
    internal func get(transactionID: String) throws -> Transaction {
        let (tx, _) = try get(transactionID: transactionID, loadAsset: false)
        return tx
    }
    
    internal func getWithAsset(transactionID: String) throws -> (Transaction, Asset) {
        let (tx, asset) = try get(transactionID: transactionID, loadAsset: true)
        return (tx, asset!)
    }
    
    internal func get(transactionID: String, loadAsset: Bool) throws -> (Transaction, Asset?) {
        var urlComponents = URLComponents(url: endpoint.apiServerURL.appendingPathComponent("/v5/txs/" + transactionID), resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [URLQueryItem(name: "pending", value: "true")]
        if loadAsset {
            urlComponents.queryItems?.append(URLQueryItem(name: "asset", value: "true"))
        }
        
        let urlRequest = URLRequest(url: urlComponents.url!)
        let (data, _) = try urlSession.synchronousDataTask(with: urlRequest)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        let result = try decoder.decode(TransactionQueryResponse.self, from: data)
        return (result.tx, result.asset)
    }
    
    internal func listTransaction(builder: Transaction.QueryParam) throws -> ([Transaction], [Asset]?, [Block]?) {
        let requestURL = builder.buildURL(baseURL: endpoint.apiServerURL, path: "/v5/txs")
        let urlRequest = URLRequest(url: requestURL)
        let (data, _) = try urlSession.synchronousDataTask(with: urlRequest)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        let result = try decoder.decode(TransactionsQueryResponse.self, from: data)
        return (result.txs, result.assets, result.blocks)
    }
}
