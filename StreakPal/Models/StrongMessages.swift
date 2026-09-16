//
//  StrongMessages.swift
//  StreakPal
//
//  Created by Ethan Marshall on 9/26/21.
//

import Foundation

/// Strongly worded messages for friends who haven't sent their streaks.
nonisolated enum StrongMessages {

    static let all: [String] = [
        String(localized: "Have you opened Snapchat recently? As you think of your response to this question, ponder this instead: the very fact you are receiving this message indicates that you have not, in fact, checked Snapchat recently. Because if you had, then you would’ve noticed that one (or more) of your streaks is almost out. And noticing that timer icon, you would’ve immediately thought to yourself, “Oh my! My streak has almost expired! I need to send a snap right away!”, sent the snap, and saved the streak. But no. You chose to live the life of an ignorant peanut, oblivious to the twists and turns, the rushing tides, of the world around you. You absolute walnut. Do you have any idea how EASY it is to send a streak? A few taps. Mere seconds of your time. Send a blank screen! Draw an “S”! Do literally anything. But no. You, the ever-so-busy, cannot be bothered to save that burning digital fire which unites you and your friends. Shame on you."),
        String(localized: "You must send your streaks. You simply must. There is no other option."),
        String(localized: "URGENT NOTIFICATION! URGENT NOTIFICATION! IT IS VERY IMPORTANT THAT YOU READ THIS! Your streaks are about to run out! Aaaaaaahhhh, panic!"),
        String(localized: "Everyone remain calm. Remain calm. REMAIN CALM. OUR STREAKS ARE RUNNING OUT!!! AAAAAAA!!!"),
        String(localized: "This is an urgent message. If you do not send your streaks right away, there will be dire consequences for the entire world. This message will self-destruct in five seconds."),
        String(localized: "We-oo, we-oo! Streak police here! Send 'em! Or else! We-oo, we-oo!"),
        String(localized: "Oh. My. God. Ohmygod. Ohhhhhhhhhmmmmmyyyyyyygoddddddddd. SEND YOUR STREAKS!!!"),
    ]

    /// A random message, ready to share.
    static func random() -> String {
        all.randomElement() ?? ""
    }
}
