//
//  SetupSequence2.swift
//  StreakPal
//
//  Created by Ethan Marshall on 3/28/20.
//

import SwiftUI

struct SetupSequence2: View {
    
    // Variables
    @EnvironmentObject var userData: UserData
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("When would you like to be reminded to send your streaks? StreakPal recommends two reminders per day.")
                .padding()
            Spacer()
            Form {
                Section {
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
            }
            Spacer()
            Button(action: {
                self.isShowing.toggle()
                //self.presentationMode.wrappedValue.dismiss()
                self.userData.didSetup = true
                self.userData.setupNotifs()
            }) {
                Text("Finish")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .padding()
                .padding(.horizontal, 80.0)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
                .background(Color.accentColor)
                .cornerRadius(10)
                .padding()
            }
        }
    }
}

/*struct SetupSequence2_Previews: PreviewProvider {
    static var previews: some View {
        SetupSequence2().environmentObject(UserData())
    }
}
*/
