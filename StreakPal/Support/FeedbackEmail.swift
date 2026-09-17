//
//  FeedbackEmail.swift
//  StreakPal
//
//  Created by Ethan Marshall on 9/17/26.
//

import Foundation

/// The prefilled feedback email, opened in whichever mail app the user has set as their default.
nonisolated enum FeedbackEmail {

    static let address = "04.uphill_kennels@icloud.com"

    /// A `mailto:` URL carrying the recipient, subject, and a short prompt in the body.
    static var url: URL {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = address
        components.queryItems = [
            URLQueryItem(name: "subject", value: String(localized: "StreakPal App Feedback")),
            URLQueryItem(name: "body", value: String(localized: "Please provide your feedback below. Feature suggestions, bug reports, and more are all appreciated! :)\n\n(If applicable, you may be contacted for more information or for follow-up questions.)\n\n\n")),
        ]
        return components.url ?? URL(string: "mailto:\(address)")!
    }
}
