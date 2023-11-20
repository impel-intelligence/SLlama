//
//  File.swift
//  
//
//  Created by Taylor Lineman on 11/19/23.
//

import Foundation

public struct EmbeddingSettings: Codable {
    /// Text to process
    public let content: String
    
    public init(content: String) {
        self.content = content
    }
}
