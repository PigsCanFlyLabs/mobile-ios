//
//  SpaceBeaverApp.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 01.03.2022.
//

import AppCenter
import SwiftUI

@main
struct SpaceBeaverApp: App {

    init() {
        AppCenter.start(withAppSecret: ProjEnvironment.secretAppCenter, services:[])
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


struct ProjEnvironment {
    static let appId: Int16 = 1020
    static let secretAppCenter = "3251ae1e-aed4-4ca1-a995-c4e1c0305369"
}
