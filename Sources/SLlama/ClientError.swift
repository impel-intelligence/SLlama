//
//  ClientError.swift
//  SLlama
//
//  Created by Taylor Lineman on 6/12/23.
//

import Foundation

public enum SLlamaClientError: LocalizedError {
    case invalidBaseURL
    case invalidURLResponse
    case invalidModel(error: Error, content: Data)
}

