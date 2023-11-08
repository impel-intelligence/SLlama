//
//  File.swift
//  
//
//  Created by Taylor Lineman on 11/8/23.
//

import Foundation

public struct CompletionResult: Codable {
    /// completion result as a string (excluding stopping_word if any). In case of streaming mode, will contain the next token as a string.
    public let content: String
    
    /// Boolean for use with stream to check whether the generation has stopped (Note: This is not related to stopping words array stop from input options)
    public let stop: Bool
    
    /// The provided options above excluding prompt but including n_ctx, model
    public let generation_settings: CompletionSettings?
    
    /// The path to the model loaded with -m
    public let model: String?
    
    /// The provided prompt
    public let prompt: String?
    
    /// Indicating whether the completion has stopped because it encountered the EOS token
    public let stopped_eos: Bool?
    
    /// Indicating whether the completion stopped because n_predict tokens were generated before stop words or EOS was encountered
    public let stopped_limit: Bool?
    
    /// Indicating whether the completion stopped due to encountering a stopping word from stop JSON array provided
    public let stopped_word: Bool?
    
    /// The stopping word encountered which stopped the generation (or "" if not stopped due to a stopping word)
    public let stopping_word: String?
    
    /// Hash of timing information about the completion such as the number of tokens predicted_per_second
    public let timings: Timings?
    
    /// Number of tokens from the prompt which could be re-used from previous completion (n_past)
    public let tokens_cached: Int?
    
    /// Number of tokens evaluated in total from the prompt
    public let tokens_evaluated: Int?
    
    /// Boolean indicating if the context size was exceeded during generation, i.e. the number of tokens provided in the prompt (tokens_evaluated) plus tokens generated (tokens predicted) exceeded the context size (n_ctx)
    public let truncated: Bool?
}
