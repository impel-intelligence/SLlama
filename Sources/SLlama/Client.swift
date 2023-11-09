//
//  Client.swift
//  SLlama
//
//  Created by Taylor Lineman on 11/8/23.
//

import Foundation

public protocol ClientStreamDelegate {
    func didReceiveModel<Model: Codable>(model: Model)
    func didFinish(error: Error?)
}

public class ClientStream<Model: Codable>: NSObject, URLSessionDataDelegate {
    public enum StreamStatus {
        case none
        case started
        case suspended
        case canceled
        case finished
    }
    
    private var session: URLSession! = nil
    private var task: URLSessionTask? = nil
    
    public var delegate: ClientStreamDelegate?
    public var status: StreamStatus = .none
    
    init(request: URLRequest) {
        super.init()
        
        self.session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        self.task = self.session.dataTask(with: request)
    }
    
    public func resumeStream() {
        task?.resume()
        status = .started
    }
    
    public func cancelStream() {
        task?.cancel()
        status = .canceled
    }
    
    public func suspendStream() {
        task?.suspend()
        status = .suspended
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard var string = String(data: data, encoding: .utf8) else { return }
        string = string.replacingOccurrences(of: "data: ", with: "")

        guard let stringData = string.data(using: .utf8) else { return }

        let model = try? Model.decode(data: stringData)
        
        delegate?.didReceiveModel(model: model)
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error as NSError? {
            print("Error: \(error)")
        } else {
            print("task complete")
        }
        
        status = .finished
        delegate?.didFinish(error: error)
    }
}

public struct Client {
    private let baseURLString: String
    private var session: URLSession

    public init(baseURLString: String, session: URLSession = .shared) {
        self.baseURLString = baseURLString
        self.session = session
    }
    
    public func stream<Model>(_ request: Request<Model>) throws -> ClientStream<Model> {
        guard let requestComponents = URLComponents(baseURL: baseURLString, request: request) else {
            throw SLlamaClientError.invalidBaseURL
        }

        guard let url = requestComponents.url else {
            throw SLlamaClientError.invalidBaseURL
        }
        
        let urlRequest = try URLRequest(url: url, request: request)
                
        return ClientStream.init(request: urlRequest)
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
