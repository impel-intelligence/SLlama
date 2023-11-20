//
//  URLRequest+Request.swift
//  SLlama
//
//  Created by Taylor Lineman on 6/12/23.
//

import Foundation

extension URLRequest {
    init<Model>(url: URL, request: Request<Model>) throws {
        self.init(url: url, timeoutInterval: 30)

        httpMethod = request.method.name
        httpBody = try request.method.httpBody
        
        addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}

extension URLComponents {
    init?<Model>(baseURL: String, request: Request<Model>) {
        guard let baseURL = URL(string: baseURL) else { return nil }
        guard let completeURL = URL(string: request.path, relativeTo: baseURL) else { return nil }
        self.init(url: completeURL, resolvingAgainstBaseURL: true)
        
        path = request.path
    }
}
