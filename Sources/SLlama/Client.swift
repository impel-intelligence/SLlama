//
//  Client.swift
//  SLlama
//
//  Created by Taylor Lineman on 11/8/23.
//

import Foundation

public struct Client {
    private let baseURLString: String
    private var session: URLSession

    public init(baseURLString: String, session: URLSession = .shared) {
        self.baseURLString = baseURLString
        self.session = session
    }
    
    public func getStream<Model>(_ request: Request<Model>) throws -> ClientStream<Model> {
        guard let requestComponents = URLComponents(baseURL: baseURLString, request: request) else {
            throw SLlamaClientError.invalidBaseURL
        }

        guard let url = requestComponents.url else {
            throw SLlamaClientError.invalidBaseURL
        }
        
        let urlRequest = try URLRequest(url: url, request: request)
        
        return ClientStream<Model>(request: urlRequest)
    }
    
    public func stream<Model>(_ request: Request<Model>) throws -> AsyncThrowingStream<Model, Error> {
        AsyncThrowingStream { continuation in
            do {
                guard let requestComponents = URLComponents(baseURL: baseURLString, request: request) else {
                    throw SLlamaClientError.invalidBaseURL
                }

                guard let url = requestComponents.url else {
                    throw SLlamaClientError.invalidBaseURL
                }
                
                let urlRequest = try URLRequest(url: url, request: request)
                let stream = ClientStream<Model>(request: urlRequest)
                stream.didReceiveModel = { _, model in
                    continuation.yield(model)
                }
                
                stream.didFinish = { stream, error in
                    continuation.finish(throwing: error)
                }
                
                stream.resumeStream()
            } catch {
                continuation.finish(throwing: error)
            }
        }
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
