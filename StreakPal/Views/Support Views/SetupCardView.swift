//
//  SetupCardView.swift
//  StreakPal
//
//  Created by Ethan Marshall on 3/28/20.
//

import SwiftUI

struct SetupCardView: View {
    
    // Variables
    @EnvironmentObject var userData: UserData
    @State var time1: String = "Time 1"
    @State var time2: String = "Time 2"
    @Binding var showingSettings: Bool
    
    var body: some View {
        VStack {
            HStack {
                VStack() {
                    Text("NO STREAK REMINDERS")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .fixedSize()
                }
                .layoutPriority(100)
            }
            
        .padding()
            Button(action: { self.showingSettings.toggle() }) {
                Text("Set Up Reminders...")
                .font(.headline)
                .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .padding()
                .padding(.horizontal, 1.0)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
                .background(Color.accentColor)
                .cornerRadius(10)
            }
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

/*struct SetupCardView_Previews: PreviewProvider {
    static var previews: some View {
        SetupCardView().environmentObject(UserData())
    }
}*/
