//
//  Block.swift
//  BitmarkSDK
//
//  Created by Macintosh on 7/6/19.
//  Copyright © 2019 Bitmark. All rights reserved.
//

import Foundation

public struct Block: Codable {
    public let number: Int64
    public let hash: String
    public let bitmark_id: String
    public let created_at: Date

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        number = try values.decode(Int64.self, forKey: .number)
        hash = try values.decode(String.self, forKey: .hash)
        bitmark_id = try values.decode(String.self, forKey: .bitmark_id)

        do {
            created_at = try values.decode(Date.self, forKey: .created_at)
        } catch { // server returns different dateFormat in Block
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            let createdAtStr = try values.decode(String.self, forKey: .created_at)
            created_at = dateFormat.date(from: createdAtStr) ?? Date()
        }
    }
}

extension Block: Equatable {
    public static func == (lhs: Block, rhs: Block) -> Bool {
        return lhs.number == rhs.number
    }
}
