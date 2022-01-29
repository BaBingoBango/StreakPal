//
//  ColorEngine.swift
//  StreakPal
//
//  Created by Ethan Marshall on 6/16/20.
//

import Foundation
import SwiftUI

struct ColorEngine {
    
    static func matchColor(color: String) -> Color {
        let allColors: [Color] = [Color.primary, Color.blue, Color.gray, Color.green, Color.accentColor, Color.pink, Color.purple, Color.red, Color.yellow]
        
        for eachColor in allColors {
            if eachColor.description == color.description {
                return eachColor
            }
        }
        return Color.blue
    }
    
    static func getEmojiOptions() -> [String] {
        var answer = [String]()
        for i in 0x1F601...0x1F64F {
            let c = String(UnicodeScalar(i) ?? "-")
            answer.append(c)
        }
        return answer
    }
}

extension Color {
    static let gold = Color("gold")
    static let silver = Color("silver")
    static let bronze = Color("bronze")
}
