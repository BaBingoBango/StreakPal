//
//  EntryPoint.swift
//  StreakPal
//
//  Created by Ethan Marshall on 9/26/21.
//

import SwiftUI

/// The entry point for the app. It decides whether or not to assign a NavigationView to the MainScreen view.
struct EntryPoint: View {
    
    // Variables
    @EnvironmentObject var userData: UserData
    @State var showingSettingsForPad = false
    
    var body: some View {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading) {
                        MainScreen()
                    }
                }
            }
        } else {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    Text("StreakPal")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding([.top, .leading])
                    
                    MainScreen()
                    
                    Button(action: {
                        self.showingSettingsForPad = true
                    }) {
                        HStack {
                            Image("gear")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .imageScale(.large)
                            .padding(.leading, 7)
                            VStack(alignment: .leading) {
                                Text("Settings")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.leading)
                                    .foregroundColor(.primary)
                            }
                            Spacer()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
                        .padding()
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.4), lineWidth: 3)
                        )
                            .padding([.leading, .bottom, .trailing])
                    }
                    .sheet(isPresented: $showingSettingsForPad) {
                        SettingsView(isPresented: $showingSettingsForPad)
                    }
                    
                }
            }
        }
        
    }
}

struct EntryPoint_Previews: PreviewProvider {
    static var previews: some View {
        EntryPoint().environmentObject(UserData())
    }
}
