//
//  ContentView.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 01.03.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModelSetup = SetupViewModel.shared

    init(){
        for family in UIFont.familyNames {
             print(family)

             for names in UIFont.fontNames(forFamilyName: family){
             print("== \(names)")
             }
        }
    }
    
    var body: some View {
        Group {
            switch viewModelSetup.flow {
            case .waitingForDevice:
                SetupSatelliteView()
            case .noConnectionWithDevice:
                FailedToConnectView()
            case .registerDevice:
                SetupConnectView()
            case .finished:
                TabsView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
