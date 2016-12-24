//
//  BitmarkDataError.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/20/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import Foundation

public enum BMErrorType {
    case system
    case parameter
}

public struct BMError: Error {
    public let debugDescription: String
    public let type: BMErrorType
    
    public init(_ description: String, type: BMErrorType = .parameter) {
        self.debugDescription = description
        self.type = type
    }
}

extension BMError: Equatable {
    public static func ==(lhs: BMError, rhs: BMError) -> Bool {
        return lhs.debugDescription == rhs.debugDescription
            && lhs.type == rhs.type
    }
}

extension BMError: CustomStringConvertible {
    public var description: String {
        return debugDescription
    }
}
