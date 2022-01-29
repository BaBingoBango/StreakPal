//
//  Notif.swift
//  StreakPal
//
//  Created by Ethan Marshall on 6/21/20.
//

import Foundation

struct Notif: Codable, Identifiable {
    
    // Variables
    var id = UUID()
    var recipSN: String
    var senderSN: String
    
    // Enums
    enum CodingKeys: String, CodingKey {
        case recipSN
        case senderSN
    }
}
