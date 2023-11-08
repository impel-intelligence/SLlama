//
//  File.swift
//  
//
//  Created by Taylor Lineman on 11/8/23.
//

import Foundation

public struct CompletionSettings: Codable {
    public struct SystemPrompt: Codable {
        public let prompt: String
        public let anti_prompt: String
        public let assistant_name: String

    }
    
    /// Provide the prompt for this completion as a string or as an array of strings or numbers representing tokens. Internally, the prompt is compared to the previous completion and only the "unseen" suffix is evaluated. If the prompt is a string or an array with the first element given as a string, a bos token is inserted in the front like main does.
    public let prompt: String?
    
    ///  Adjust the randomness of the generated text (default: 0.8).
    public let temperature: Double?
    
    /// Limit the next token selection to the K most probable tokens (default: 40).
    public let top_k: Int?
    
    /// Limit the next token selection to a subset of tokens with a cumulative probability above a threshold P (default: 0.95).
    public let top_p: Double?
    
    /// Set the maximum number of tokens to predict when generating text. Note: May exceed the set limit slightly if the last token is a partial multibyte character. When 0, no tokens will be generated but the prompt is evaluated into the cache. (default: -1, -1 = infinity).
    public let n_predict: Int?
    
    /// Specify the number of tokens from the prompt to retain when the context size is exceeded and tokens need to be discarded. By default, this value is set to 0 (meaning no tokens are kept). Use -1 to retain all tokens from the prompt.
    public let n_keep: Int?
    
    /// It allows receiving each predicted token in real-time instead of waiting for the completion to finish. To enable this, set to
    public let stream: Bool?
    
    /// Specify a JSON array of stopping strings. These words will not be included in the completion, so make sure to add them to the prompt for the next iteration (default: []).
    public let stop: [String]?
    
    /// Enable tail free sampling with parameter z (default: 1.0, 1.0 = disabled).
    public let tfs_z: Double?
    
    /// Enable locally typical sampling with parameter p (default: 1.0, 1.0 = disabled).
    public let typical_p: Double?
    
    /// Control the repetition of token sequences in the generated text (default: 1.1).
    public let repeat_penalty: Double?
    
    /// Last n tokens to consider for penalizing repetition (default: 64, 0 = disabled, -1 = ctx-size).
    public let repeat_last_n: Int?
    
    /// Penalize newline tokens when applying the repeat penalty (default: true).
    public let penalize_nl: Bool?
    
    /// Repeat alpha presence penalty (default: 0.0, 0.0 = disabled).
    public let presence_penalty: Double?
    
    /// Repeat alpha frequency penalty (default: 0.0, 0.0 = disabled);
    public let frequency_penalty: Double?
    
    /// Enable Mirostat sampling, controlling perplexity during text generation (default: 0, 0 = disabled, 1 = Mirostat, 2 = Mirostat 2.0).
    public let mirostat: Int?
    
    /// Set the Mirostat target entropy, parameter tau (default: 5.0).
    public let mirostat_tau: Int?
    
    /// Set the Mirostat learning rate, parameter eta (default: 0.1).
    public let mirostat_eta: Double?
    
    /// Set grammar for grammar-based sampling (default: no grammar)
    public let grammer: String?
    
    /// Set the random number generator (RNG) seed (default: -1, -1 = random seed).
    public let seed: Int?
    
    /// Ignore end of stream token and continue generating (default: false).
    public let ignore_eos: Bool?
    
    /// Modify the likelihood of a token appearing in the generated text completion. For example, use "logit_bias": [[15043,1.0]] to increase the likelihood of the token 'Hello', or "logit_bias": [[15043,-1.0]] to decrease its likelihood. Setting the value to false, "logit_bias": [[15043,false]] ensures that the token Hello is never produced (default: [])
    public let logit_bias: [[Int]]?
    
    /// If greater than 0, the response also contains the probabilities of top N tokens for each generated token (default: 0)
    public let n_probs: Int?
 
    /// An array of objects to hold base64-encoded image data and its ids to be reference in prompt. You can determine the place of the image in the prompt as in the following: USER:[img-12]Describe the image in detail.\nASSISTANT: In this case, [img-12] will be replaced by the embeddings of the image id 12 in the following image_data array: {..., "image_data": [{"data": "<BASE64_STRING>", "id": 12}]}. Use image_data only with multimodal models, e.g., LLaVA.
    public let image_data: [String]?
    
    /// Assign the completion task to an specific slot. If is -1 the task will be assigned to a Idle slot (default: -1)
    public let slot_id: Int?
    
    /// Save the prompt and generation for avoid reprocess entire prompt if a part of this isn't change (default: false)
    public let cache_prompt: Bool?
    
    /// Change the system prompt (initial prompt of all slots), this is useful for chat applications.
    public let system_prompt: SystemPrompt?
    
    public init(prompt: String? = nil, temperature: Double? = nil, top_k: Int? = nil, top_p: Double? = nil, n_predict: Int? = nil, n_keep: Int? = nil, stream: Bool? = nil, stop: [String]? = nil, tfs_z: Double? = nil, typical_p: Double? = nil, repeat_penalty: Double? = nil, repeat_last_n: Int? = nil, penalize_nl: Bool? = nil, presence_penalty: Double? = nil, frequency_penalty: Double? = nil, mirostat: Int? = nil, mirostat_tau: Int? = nil, mirostat_eta: Double? = nil, grammer: String? = nil, seed: Int? = nil, ignore_eos: Bool? = nil, logit_bias: [[Int]]? = nil, n_probs: Int? = nil, image_data: [String]? = nil, slot_id: Int? = nil, cache_prompt: Bool? = nil, system_prompt: SystemPrompt? = nil) {
        self.prompt = prompt
        self.temperature = temperature
        self.top_k = top_k
        self.top_p = top_p
        self.n_predict = n_predict
        self.n_keep = n_keep
        self.stream = stream
        self.stop = stop
        self.tfs_z = tfs_z
        self.typical_p = typical_p
        self.repeat_penalty = repeat_penalty
        self.repeat_last_n = repeat_last_n
        self.penalize_nl = penalize_nl
        self.presence_penalty = presence_penalty
        self.frequency_penalty = frequency_penalty
        self.mirostat = mirostat
        self.mirostat_tau = mirostat_tau
        self.mirostat_eta = mirostat_eta
        self.grammer = grammer
        self.seed = seed
        self.ignore_eos = ignore_eos
        self.logit_bias = logit_bias
        self.n_probs = n_probs
        self.image_data = image_data
        self.slot_id = slot_id
        self.cache_prompt = cache_prompt
        self.system_prompt = system_prompt
    }
}
