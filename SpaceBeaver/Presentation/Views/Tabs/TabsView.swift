//
//  TabsView.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 02.03.2022.
//

import SwiftUI

struct TabsView: View {


    var body: some View {
        NavigationView {
            TabView {
                 MessagesView()
                     .tabItem {
                         Icons.messages
                     }
                     .overlay {
                         VStack {
                             Color.clear
                             SeparatorLine()
                         }
                     }
                
                SettingsView()
                     .tabItem {
                         Icons.settings
                     }
                     .overlay {
                         VStack {
                             Color.clear
                             SeparatorLine()
                         }
                     }
             }
            .accentColor(Colors.colorBlack)

        }
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}


