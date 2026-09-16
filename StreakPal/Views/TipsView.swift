//
//  TipsView.swift
//  StreakPal
//
//  Created by Ethan Marshall on 8/30/20.
//

import SwiftUI

/// A few tips for keeping Snapstreaks alive, presented as a sheet.
struct TipsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    Tip(
                        title: "Send streaks twice a day",
                        color: .red,
                        detail: "Sending streaks both in the morning and in the evening ensures you always maintain your end of the streak and creates an easy routine.\n\nIf you send streaks only once per day, you'll have to send them earlier and earlier each day in order to maintain the 24-hour requirement.")
                    Tip(
                        title: "Use a Shortcut to send faster",
                        color: .accentColor,
                        detail: "Snapchat's Shortcuts feature allows you to snap multiple friends at once in only a single tap. Creating a \"streaks\" shortcut will enable you to select all the friends you have streaks with instantly instead of one by one.")
                    Tip(
                        title: "Only Snaps count for streaks",
                        color: .yellow,
                        detail: "Both photo and video Snaps are valid for streaks. However, Chats and Snaps to group chats will not count. Furthermore, Snaps sent with Memories content are also invalid for streaks.")
                }
                .padding()
            }
            .navigationTitle("Streak Tips")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

/// One tip: a colored headline followed by its explanation.
private struct Tip: View {
    let title: LocalizedStringKey
    let color: Color
    let detail: LocalizedStringKey

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3.bold())
                .foregroundStyle(color)
            Text(detail)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    TipsView()
}
