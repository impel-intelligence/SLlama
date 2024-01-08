//
//  ClientStream.swift
//  SLlama
//
//  Created by Taylor Lineman on 11/9/23.
//

import Foundation

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
    
    public var status: StreamStatus = .none
    
    public var didReceiveModel: ((_ session: ClientStream, _ model: Model) -> ())? = nil
    public var didFinish: ((_ session: ClientStream, _ error: Error?) -> ())? = nil

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

        guard let model = try? Model.decode(data: stringData) else { return }
        
        didReceiveModel?(self, model)
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error as NSError? {
            print("Error: \(error)")
        } else {
            print("task complete")
        }
        
        status = .finished
        didFinish?(self, error)
    }
}
