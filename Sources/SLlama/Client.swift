//
//  Client.swift
//  SLlama
//
//  Created by Taylor Lineman on 11/8/23.
//

import Foundation

public class Client: NSObject {
    enum StreamStatus {
        case none
        case preparing
        case started
        case stopped
    }
    
    struct StreamConfiguration {
        let model: Codable.Type
    }
    
    private let baseURLString: String
    private var session: URLSession! = nil

    private var streamingTask: URLSessionDataTask? = nil
    private var streamConfig: StreamConfiguration? = nil
    
    var streamStatus: StreamStatus = .none
    

    public init(baseURLString: String) {
        self.baseURLString = baseURLString
        super.init()

        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
    }
    
    public func stream<Model>(_ request: Request<Model>) throws {
        guard let requestComponents = URLComponents(baseURL: baseURLString, request: request) else {
            throw SLlamaClientError.invalidBaseURL
        }

        guard let url = requestComponents.url else {
            throw SLlamaClientError.invalidBaseURL
        }
        
        streamStatus = .preparing
        let urlRequest = try URLRequest(url: url, request: request)

        let task = self.session.dataTask(with: urlRequest)

        self.streamingTask = task
        
        streamConfig = .init(model: Model.self)
        streamStatus = .started
        task.resume()
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

extension Client: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let streamConfig else { return }
        guard var string = String(data: data, encoding: .utf8) else { return }
        string = string.replacingOccurrences(of: "data: ", with: "")
        
        guard let stringData = string.data(using: .utf8) else { return }
        
        let model = try? streamConfig.model.decode(data: stringData)
        print(model)
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error as NSError? {
            print("Error: \(error)")
        } else {
            print("task complete")
        }
        streamStatus = .stopped
    }

}
