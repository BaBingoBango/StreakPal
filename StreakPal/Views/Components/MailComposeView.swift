//
//  MailComposeView.swift
//  StreakPal
//
//  Created by Ethan Marshall on 3/28/20.
//

import MessageUI
import SwiftUI

/// Presents the system mail composer prefilled for app feedback.
struct MailComposeView: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss

    /// Whether the device has a mail account the composer can use.
    static var canSendMail: Bool {
        MFMailComposeViewController.canSendMail()
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = context.coordinator
        composer.setToRecipients(["04.uphill_kennels@icloud.com"])
        composer.setSubject(String(localized: "StreakPal App Feedback"))
        composer.setMessageBody(
            String(localized: "Please provide your feedback below. Feature suggestions, bug reports, and more are all appreciated! :)\n\n(If applicable, you may be contacted for more information or for follow-up questions.)\n\n\n"),
            isHTML: false)
        return composer
    }

    func updateUIViewController(_ composer: MFMailComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(dismiss: dismiss)
    }

    final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        private let dismiss: DismissAction

        init(dismiss: DismissAction) {
            self.dismiss = dismiss
        }

        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: (any Error)?
        ) {
            dismiss()
        }
    }
}
