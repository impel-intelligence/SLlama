//
//  PromptProcessor.swift
//  SLlama
//
//  Created by Taylor Lineman on 11/8/23.
//

import Foundation

public struct PromptProcessor {
    public static let SYSTEM_MESSAGE_INSERT = "{{SYSTEM}}"
    public static let USER_MESSAGE_INSERT = "{{USER}}"
    
    public static func prepareTemplate(template: String, systemPrompt: String, userPrompt: String) -> String {
        let editedUserPrompt = userPrompt.replacingOccurrences(of: "\n", with: " ")
        var filledTemplate = template
        filledTemplate = filledTemplate.replacingOccurrences(of: SYSTEM_MESSAGE_INSERT, with: systemPrompt)
        filledTemplate = filledTemplate.replacingOccurrences(of: USER_MESSAGE_INSERT, with: editedUserPrompt)
        
        return filledTemplate
    }
}
