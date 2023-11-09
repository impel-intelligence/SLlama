//
//  PromptProcessor.swift
//  SLlama
//
//  Created by Taylor Lineman on 11/8/23.
//

import Foundation

struct PromptProcessor {
    static let SYSTEM_MESSAGE_INSERT = "{{SYSTEM}}"
    static let USER_MESSAGE_INSERT = "{{USER}}"
    
    static func prepareTemplate(template: String, systemPrompt: String, userPrompt: String) -> String {
        let editedUserPrompt = userPrompt.replacingOccurrences(of: "\n", with: " ")
        var filledTemplate = template
        filledTemplate = template.replacingOccurrences(of: SYSTEM_MESSAGE_INSERT, with: systemPrompt)
        filledTemplate = template.replacingOccurrences(of: USER_MESSAGE_INSERT, with: editedUserPrompt)
        
        return filledTemplate
    }
}
