//
//  Payload.swift
//  SLlama
//
//  Created by Taylor Lineman on 11/8/23.
//

import Foundation

enum Payload {
    case body(model: Codable)
    case empty
}

extension Payload {
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var data: Data? {
        get throws {
            switch self {
            case .body(let model):
                return try JSONEncoder().encode(model)
            case .empty:
                return nil
            }
        }
    }
    
    var type: String? {
        switch self {
        case .body:
            return "application/json"
        case .empty:
            return nil
        }
    }
}
