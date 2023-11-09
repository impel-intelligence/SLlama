//
//  LlamaRequests.swift
//  SLlama
//
//  Created by Taylor Lineman on 11/8/23.
//

import Foundation

public enum LlamaRequests {
    public static func completion(_ parameters: CompletionSettings) -> Request<CompletionResult> {
        return Request(path: "/completion", method: .post(.body(model: parameters)))
    }
}
