//
//  File.swift
//  
//
//  Created by Taylor Lineman on 6/12/23.
//

import Foundation

extension Decodable {
    public static func decode(data: Data) throws -> Self {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Self.self, from: data)
    }
}
