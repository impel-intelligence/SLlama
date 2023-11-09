//
//  ToDelimitedList.swift
//  SLlama
//
//  Created by Taylor Lineman on 6/13/23.
//

import Foundation

extension [String] {
    func toCommaDelimited() -> String? {
        if self.isEmpty {
            return nil
        }
        return self.joined(separator: ",")
    }
}
