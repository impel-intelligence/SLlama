//
//  HTTPMethod.swift
//
//
//  Created by Taylor Lineman on 11/8/23.
//

import Foundation

enum HTTPMethod {
    case get(Payload)
    case post(Payload)
    case put(Payload)
    case patch(Payload)
    case delete(Payload)
}

extension HTTPMethod {
    var name: String {
        switch self {
        case .get: 
            return "GET"
        case .post:
            return "POST"
        case .put: 
            return "PUT"
        case .delete: 
            return "DELETE"
        case .patch: 
            return "PATCH"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .get(let payload), .post(let payload), .put(let payload), .patch(let payload), .delete(let payload):
            return payload.queryItems
        }
    }

    var httpBody: Data? {
        get throws {
            switch self {
            case .get(let payload), .post(let payload), .put(let payload), .patch(let payload), .delete(let payload):
                return try payload.data
            }
        }
    }

    var contentType: String? {
        switch self {
        case .get(let payload), .post(let payload), .put(let payload), .patch(let payload), .delete(let payload):
            return payload.type
        }
    }
}
