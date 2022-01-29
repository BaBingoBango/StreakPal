//
//  StringEngine.swift
//  StreakPal
//
//  Created by Ethan Marshall on 6/21/20.
//

import Foundation

struct StringEngine {
  static func blank(text: String) -> Bool {
    let trimmed = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    return trimmed.isEmpty
  }
}
