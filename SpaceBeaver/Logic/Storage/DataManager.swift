//
//  DataManager.swift
//  Storage
//
//  Created by Dmytro Kholodov on 27.05.2021.
//  Copyright © 2020 CookieDev. All rights reserved.
//

import Foundation
import Combine

class DataManager {
    static let shared = DataManager()
    private let defaults = UserDefaults.standard

    lazy var storage: DialogsStorage? = {
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Int(Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String ?? "0")
        else { fatalError("Expected to find a bundle version in the info dictionary") }
        let _storage = DialogsStorage(cleanInstall: true)
        return _storage
    }()

}

