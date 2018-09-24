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
        let txId: String
    }
    internal func transfer(_ transfer: TransferParams) throws -> String {
        let json = try JSONSerialization.data(withJSONObject: transfer.toJSON(), options: [])
        
        let requestURL = endpoint.apiServerURL.appendingPathComponent("/v3/transfer")
        
        var urlRequest = URLRequest(url: requestURL, cachePolicy: .reloadIgnoringCacheData)
        urlRequest.httpBody = json
        urlRequest.httpMethod = "POST"
        
        let (data, _) = try urlSession.synchronousDataTask(with: urlRequest)
        
        let transferResponse = try JSONDecoder().decode(TransferResponse.self, from: data)
        return transferResponse.txId
    }
    
    internal func offer(_ offer: OfferParams) throws -> String {
        let json = try JSONSerialization.data(withJSONObject: offer.toJSON(), options: [])
        
        let requestURL = endpoint.apiServerURL.appendingPathComponent("/v3/transfer")
        
        var urlRequest = URLRequest(url: requestURL, cachePolicy: .reloadIgnoringCacheData)
        urlRequest.httpBody = json
        urlRequest.httpMethod = "POST"
        
        try urlSession.synchronousDataTask(with: urlRequest)
    }
    
//    internal func response(forBitmarkID bitmarkID: String, withAction action: CountersignedTransferAction) throws -> String {
//        let requestURL = endpoint.apiServerURL.appendingPathComponent("/v2/transfer_offers")
//        
//        var params: [String: Any] = ["from": sender.accountNumber,
//                    "record": try offer.serialize()]
//        if let extraInfo = extraInfo {
//            params["extra_info"] = extraInfo
//        }
//        
//        var urlRequest = URLRequest(url: requestURL)
//        urlRequest.httpMethod = "POST"
//        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
//        
//        let action = "transferOffer"
//        let resource = String(data: try JSONEncoder().encode(try offer.serialize()), encoding: .utf8)!
//        
//        try urlRequest.signRequest(withAccount: sender, action: action, resource: resource)
//        
//        let (d, res) = try urlSession.synchronousDataTask(with: urlRequest)
//        guard let response = res,
//            let data = d else {
//            throw("Cannot get http response")
//        }
//        
//        if !(200..<300 ~= response.statusCode) {
//            throw("Request status" + String(response.statusCode))
//        }
//        
//        let responseData = try JSONDecoder().decode([String: String].self, from: data)
//        guard let offerId = responseData["offer_id"] else {
//            throw("Invalid response from gateway server")
//        }
//        
//        return offerId
//    }
//    
//    internal func completeTransferOffer(withAccount account: Account, offerId: String, action: String, counterSignature: String) throws -> Bool {
//        let requestURL = endpoint.apiServerURL.appendingPathComponent("/v2/transfer_offers")
//        
//        let params: [String: Any]  = ["id": offerId,
//                                      "reply":
//                                        ["action": action,
//                                         "countersignature": counterSignature]]
//        
//        var urlRequest = URLRequest(url: requestURL)
//        urlRequest.httpMethod = "PATCH"
//        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
//        try urlRequest.signRequest(withAccount: account, action: "transferOffer", resource: "patch")
//        
//        let (d, res) = try urlSession.synchronousDataTask(with: urlRequest)
//        guard let response = res,
//            let _ = d else {
//                throw("Cannot get http response")
//        }
//        
//        if !(200..<300 ~= response.statusCode) {
//            return false
//        }
//        
//        return true
//    }
//    
//    internal func getTransferOffer(withId offerID: String) throws -> TransferOffer {
//        var url = URLComponents(url: endpoint.apiServerURL.appendingPathComponent("/v2/transfer_offers"), resolvingAgainstBaseURL: false)!
//        url.queryItems = [
//            URLQueryItem(name: "offer_id", value: offerID)
//        ]
//        
//        let urlRequest = URLRequest(url: url.url!)
//        
//        let (d, res) = try urlSession.synchronousDataTask(with: urlRequest)
//        guard let response = res,
//            let data = d else {
//                throw("Cannot get http response")
//        }
//        
//        if !(200..<300 ~= response.statusCode) {
//            throw("Request status" + String(response.statusCode))
//        }
//        
//        guard let responseData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
//            throw("Cannot parse response")
//        }
//        
//        guard let offerInfo = responseData["offer"] as? [String: Any],
//            let record = offerInfo["record"] as? [String: Any],
//            let link = record["link"] as? String,
//            let owner = record["owner"] as? String,
//            let signature = record["signature"] as? String else {
//                throw("Invalid response from gateway server")
//        }
//        
//        let offer = TransferOffer(txId: link, receiver: owner, signature: signature.hexDecodedData)
//        
//        return offer
//    }
}
