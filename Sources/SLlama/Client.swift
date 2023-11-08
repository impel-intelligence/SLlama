//
//  Client.swift
//  SLlama
//
//  Created by Taylor Lineman on 11/8/23.
//

import Foundation

public struct Client {
    private let baseURLString: String
    private let session: URLSession
    
    public init(baseURLString: String, session: URLSession = .shared) {
        self.session = session
        self.baseURLString = baseURLString
    }
    
    public func run<Model>(_ request: Request<Model>) async throws -> Model {
        guard let requestComponents = URLComponents(baseURL: baseURLString, request: request) else {
            throw SLlamaClientError.invalidBaseURL
        }

        guard let url = requestComponents.url else {
            throw SLlamaClientError.invalidBaseURL
        }
        
        let urlRequest = try URLRequest(url: url, request: request)
        let task: (Data, URLResponse) = try await session.data(for: urlRequest)
        guard let response = task.1 as? HTTPURLResponse, response.statusCode == 200 else {
            throw SLlamaClientError.invalidURLResponse
        }
        
        let taskData: Data = task.0
        
        do {
            return try Model.decode(data: taskData)
        } catch {
            throw SLlamaClientError.invalidModel(error: error)
        }
    }
}
