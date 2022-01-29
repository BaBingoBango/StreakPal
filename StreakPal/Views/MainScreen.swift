//
//  MainScreen.swift
//  StreakPal
//
//  Created by Ethan Marshall on 3/28/20.
//

import SwiftUI

struct MainScreen: View {
    
    // Variables
    @EnvironmentObject var userData: UserData
    @State var showingSettings = false
    @State var showShareSheet = false
    @State var showingTips = false
    var settingsButton: some View {
        Button(action: { self.showingSettings.toggle() }) {
            Image(systemName: "gear")
                .imageScale(.large)
                .padding()
        }
    }
    
    var body: some View {
//        NavigationView {
//            ScrollView {
            VStack(alignment: .leading) {
                if userData.didSetup {
                    CardView(showingSettings: self.$showingSettings).padding(.bottom).environmentObject(userData)
                } else {
                    SetupCardView(showingSettings: self.$showingSettings).padding(.bottom).environmentObject(userData)
                }
                
                Button(action: {
                    self.showShareSheet = true
                }) {
                    HStack {
                        Image("hourglass")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .imageScale(.large)
                        .padding(.leading, 7)
                        VStack(alignment: .leading) {
                            Text("About to lose your streaks?")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.leading)
                                .foregroundColor(.primary)
                            Text("Never fear! Tap here to send your friends a strongly worded message encouraging them to snap you back!")
                                .multilineTextAlignment(.leading)
                                .padding(.leading)
                                .foregroundColor(.secondary)
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
                .sheet(isPresented: $showShareSheet) {
                    ShareSheet(activityItems: [strongMessages.randomElement()!])
                }
                
                Button(action: {
                    self.showingTips = true
                }) {
                    HStack {
                        Image("bulb")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .imageScale(.large)
                        .padding(.leading, 7)
                        VStack(alignment: .leading) {
                            Text("Snapstreak Tips!")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.leading)
                                .foregroundColor(.primary)
                            Text("Check here for some useful tricks for making sure you never lose your streaks.")
                                .multilineTextAlignment(.leading)
                                .padding(.leading)
                                .foregroundColor(.secondary)
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
                .sheet(isPresented: $showingTips) {
                    TipsView()
                }
                
                Spacer()
                
                    .navigationBarTitle(Text("StreakPal"))
                    .sheet(isPresented: $showingSettings) {
                    SettingsView(isPresented: self.$showingSettings).environmentObject(self.userData)
                    }
                    .navigationBarItems(trailing: settingsButton)
                }
//            }
//        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen().environmentObject(UserData())
    }
}


struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
      
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
      
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
      
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}
