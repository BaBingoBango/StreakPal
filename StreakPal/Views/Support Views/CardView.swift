//
//  CardView.swift
//  StreakPal
//
//  Created by Ethan Marshall on 3/28/20.
//

import SwiftUI

struct CardView: View {
    
    // Variables
    @EnvironmentObject var userData: UserData
    @Binding var showingSettings: Bool
    
    var body: some View {
        VStack {
            HStack {
                VStack() {
                    Text("STREAK REMINDERS")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    VStack() {
                        Text((userData.getTimeFormatter().string(from: userData.firstReminderDate)))
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .lineLimit(3)
                            .fixedSize(horizontal: true, vertical: false)
                        if userData.hasTwoReminders {
                            Text("and".uppercased())
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text((userData.getTimeFormatter().string(from: userData.secondReminderDate)))
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .lineLimit(3)
                            .fixedSize(horizontal: true, vertical: false)
                        }
                    }
                }
                .layoutPriority(100)
            }
            
        .padding()
            
        }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
    .padding()
    .cornerRadius(10)
    .overlay(
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.accentColor, lineWidth: 3)
    )
    .padding([.top, .horizontal])
        .sheet(isPresented: $showingSettings) {
            SettingsView(isPresented: self.$showingSettings).environmentObject(self.userData)
        }
    }
}

/*struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView().environmentObject(UserData())
    }
}*/
