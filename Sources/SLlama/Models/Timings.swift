//
//  Timings.swift
//
//
//  Created by Taylor Lineman on 11/8/23.
//

import Foundation

public struct Timings: Codable {
    let predicted_ms: Double
    let predicted_n: Int
    let predicted_per_second: Double
    let predicted_per_token_ms: Double
    let prompt_ms: Double
    let prompt_n: Int
    let prompt_per_second: Double
    let prompt_per_token_ms: Double
}
