//
//  TipsView.swift
//  StreakPal
//
//  Created by Ethan Marshall on 8/30/20.
//

import SwiftUI

struct TipsView: View {
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var doneButton: some View {
        Button(action: {
            //self.isPresented.toggle()
            self.presentationMode.wrappedValue.dismiss()
        }) {
                Text("Done")
                    .fontWeight(.bold)
        }
    }
    var body: some View {
        NavigationView {
            
            ScrollView {
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text("Send streaks twice a day")
                            .foregroundColor(Color.red)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(.vertical)
                        Spacer()
                    }
                    
                    Text("Sending streaks both in the morning and in the evening ensures you always mantain your end of the streak and creates an easy routine.\n\nIf you send streaks only once per day, you'll have to send them earlier and earlier each day in order to mantain the 24-hour requirement.")
                        .multilineTextAlignment(.leading)
                    
                    
                    HStack {
                        Text("Use a Shortcut to send faster")
                            .foregroundColor(Color.accentColor)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(.vertical)
                        Spacer()
                    }
                    
                    Text("Snapchat's new Shortcuts feature allows you to snap multiple friends at once in only a single tap. Creating a \"streaks\" shortcut will enable you to select all the friends you have streaks with instantly instead of one by one.")
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Text("Only Snaps count for streaks")
                            .foregroundColor(Color.yellow)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(.vertical)
                        Spacer()
                    }
                    
                    Text("Both photo and video Snaps are valid for streaks. However, Chats and Snaps to group chats will not count - furthermore, Snaps sent with Memories content are also invalid for streaks.")
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                }
                .padding(.horizontal)
            }
                .navigationBarTitle(Text("Streak Tips"))
        .navigationBarItems(trailing: doneButton)
        }
    }
}

struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        TipsView()
    }
}
