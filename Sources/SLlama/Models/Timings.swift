//
//  Timings.swift
//  SLlama
//
//  Created by Taylor Lineman on 11/8/23.
//

import Foundation

public struct Timings: Codable {
    public let predicted_ms: Double?
    public let predicted_n: Int?
    public let predicted_per_second: Double?
    public let predicted_per_token_ms: Double?
    public let prompt_ms: Double?
    public let prompt_n: Int?
    public let prompt_per_second: Double?
    public let prompt_per_token_ms: Double?
}
