//
//  Bundle+Version.swift
//  StreakPal
//
//  Created by Ethan Marshall on 9/16/26.
//

import Foundation

extension Bundle {
    /// The marketing version and build number, e.g. "1.2 (5)".
    nonisolated var versionDescription: String {
        let version = infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
        let build = infoDictionary?["CFBundleVersion"] as? String ?? "?"
        return "\(version) (\(build))"
    }
}
