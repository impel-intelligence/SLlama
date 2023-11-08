//
//  Request.swift
//  SLlama
//
//  Created by Taylor Lineman on 6/12/23.
//

public struct Request<Model: Codable> {
    let path: String
    let method: HTTPMethod
    
    init(path: String, method: HTTPMethod) {
        self.path = path
        self.method = method
    }
}
