//
//  RPCTransformable.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 12/28/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import Foundation

protocol RPCTransformable {
    func getRPCParam() throws -> [String: Any]
}
