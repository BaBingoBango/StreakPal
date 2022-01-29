//
//  SetupSequence1.swift
//  StreakPal
//
//  Created by Ethan Marshall on 3/28/20.
//

import SwiftUI

struct SetupSequence1: View {
    
    // Variables
    @EnvironmentObject var userData: UserData
    @State var hasPressedNotificationsButton: Bool = false
    let center = UNUserNotificationCenter.current()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var isShowing: Bool
    
    var body: some View {
//        NavigationView {
            VStack(alignment: .leading) {
                if !hasPressedNotificationsButton {
                    Text("Allow notifications so StreakPal can remind you to send your streaks!")
                    .padding()
                } else {
                    if userData.wantsNotifications {
                        Text("Great! Tap Continue to move on.")
                        .padding()
                    } else {
                        Text("With notifications off, you will not recieve any reminders from StreakPal. You can always head to Settings to re-enable notifications.")
                        .padding()
                    }
                }
                Spacer()
                if !hasPressedNotificationsButton {
                    Button(action: {
                        self.center.requestAuthorization(options: [.alert, .sound])
                        { (granted, error) in
                            self.hasPressedNotificationsButton = true
                            if granted {
                                self.userData.wantsNotifications = true
                            }
                        }
                    }) {
                         Text("Set Notifications")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .fixedSize()
                            .padding()
                            .padding(.horizontal, 80.0)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                            .padding()
                    }
                } else {
                    if userData.wantsNotifications {
                        NavigationLink(destination: SetupSequence2(isShowing: self.$isShowing).navigationBarBackButtonHidden(true).environmentObject(userData)
                            .navigationBarTitle(Text("Set Reminder Times"))) {
                            Text("Continue")
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
                    } else {
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
        .navigationBarTitle(Text("Allow Notifications"))
            
//        }
    }
}

/*struct SetupSequence1_Previews: PreviewProvider {
    static var previews: some View {
        SetupSequence1()
    }
}
*/
