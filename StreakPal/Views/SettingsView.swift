//
//  SettingsView.swift
//  StreakPal
//
//  Created by Ethan Marshall on 3/28/20.
//

import SwiftUI
import UIKit
import MessageUI

struct SettingsView: View {
    
    // Variables
    @EnvironmentObject var userData: UserData
    @State var isShowingMailView = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var showingSetup = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var isPresented: Bool
    var doneButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
                Text("Done")
                    .fontWeight(.bold)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                if !userData.didSetup {
                    Section(header: Text("STREAK REMINDERS")) {
                        HStack {
                            Image(systemName: "arrow.up.right")
                                .resizable()
                                .foregroundColor(.accentColor)
                                .fixedSize(horizontal: true, vertical: true)
                                .clipped()
                                .aspectRatio(contentMode: .fit)
                            Button(action: { self.showingSetup.toggle() }) {
                                Text("Set Up Streak Reminders...")
                            }
                        }
                    }
                } else {
                    Section(header: Text("STREAK REMINDERS")) {
                        HStack {
                            Image(systemName: "bubble.left.and.bubble.right")
                                .resizable()
                                .fixedSize(horizontal: true, vertical: true)
                                .clipped()
                                .aspectRatio(contentMode: .fit)
                            Toggle(isOn: $userData.hasTwoReminders) {
                                Text("Two Reminders Per Day")
                            }
                        }
                        HStack {
                            Image(systemName: "alarm")
                            .resizable()
                            .fixedSize(horizontal: true, vertical: true)
                            .clipped()
                            .aspectRatio(contentMode: .fit)
                            DatePicker("First Reminder Date", selection: $userData.firstReminderDate, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                                .animation(.default)
                        }
                        if userData.hasTwoReminders {
                            HStack {
                                Image(systemName: "alarm.fill")
                                .resizable()
                                .fixedSize(horizontal: true, vertical: true)
                                .clipped()
                                .aspectRatio(contentMode: .fit)
                                DatePicker("Second Reminder Date", selection: $userData.secondReminderDate, displayedComponents: .hourAndMinute)
                                    .animation(.default)
                                .labelsHidden()
                                .animation(.default)
                            }
                        }
                    }
                    Section(header: Text("NOTIFICATIONS")) {
                        HStack {
                            Image(systemName: "arrowshape.turn.up.right.fill")
                                .resizable()
                                .fixedSize(horizontal: true, vertical: true)
                                .clipped()
                                .aspectRatio(contentMode: .fit)
                            Toggle(isOn: $userData.sendToSnap) {
                                Text("Open Snapchat on Tap")
                            }
                        }
                        if #available(iOS 15.0, *) {
                            HStack {
                                Image(systemName: "clock.badge.exclamationmark.fill")
                                    .resizable()
                                    .fixedSize(horizontal: true, vertical: true)
                                    .clipped()
                                    .aspectRatio(contentMode: .fit)
                                Toggle(isOn: $userData.isTimeSensitive) {
                                    Text("Mark as Time Sensitive")
                                }
                            }
                        }
                    }
                    
                }
                
                Section(header: Text("INFORMATION"), footer: MFMailComposeViewController.canSendMail() ? Text("") : Text("To send feedback without a mail account registered to your device, visit the support link located on StreakPal's App Store page.")) {
                    Text("Application Version: 1.1")
                        .foregroundColor(Color.gray)
                    Text("Build Number: 4")
                    .foregroundColor(Color.gray)
                    HStack {
                        Image(systemName: "hand.raised.fill")
                        .resizable()
                        .fixedSize(horizontal: true, vertical: true)
                        .clipped()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.accentColor)
                        Button( action: {
                            if let url = URL(string: "https://drive.google.com/open?id=1_pU_grtl1SHhvknDzSl6C3Aizm5LPkd4") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("View Privacy Policy")
                        }
                    }
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                        .resizable()
                        .foregroundColor(MFMailComposeViewController.canSendMail() ? .accentColor : .gray)
                        .opacity(MFMailComposeViewController.canSendMail() ? 1.0 : 0.5)
                        .fixedSize(horizontal: true, vertical: true)
                        .clipped()
                        .aspectRatio(contentMode: .fit)
                        Button( action: {
                            self.isShowingMailView = true
                        }) {
                            Text("Send Feedback")
                        }
                        .disabled(!MFMailComposeViewController.canSendMail())
                        .sheet(isPresented: $isShowingMailView) {
                            MailView2(result: self.$result)
                        }
                    }
                }
            }
        .navigationBarItems(trailing: doneButton)
        .navigationBarTitle(Text("Settings"))
        .sheet(isPresented: $showingSetup) {
            NavigationView {
                SetupSequence1(isShowing: self.$showingSetup).environmentObject(self.userData)
            }
        }
        }.onAppear {
            UITableView.appearance().separatorColor = .none
        }
        .onDisappear {
            UITableView.appearance().separatorColor = .clear
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        SettingsView(isPresented: .constant(true)).environmentObject(UserData())
    }
    
}

struct MailView2: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
    @Binding var result: Result<MFMailComposeResult, Error>?
    //var deviceID: String
    //var senderID: String

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView2>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setToRecipients(["04.uphill_kennels@icloud.com"])
        vc.setSubject("StreakPal App Feedback")
        vc.setMessageBody("Please provide your feedback below. Feature suggestions, bug reports, and more are all appreciated! :)\n\n(If applicable, you may be contacted for more information or for follow-up questions.)\n\n\n", isHTML: false)
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView2>) {

    }
}
