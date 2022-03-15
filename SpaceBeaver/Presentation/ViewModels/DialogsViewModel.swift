//
//  DialogsViewModel.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 04.03.2022.
//

import Foundation

class DialogsViewModel: ObservableObject {

    static let shared = DialogsViewModel()

    let storeDialogs = DialogsStore.makeStore()

    @Published var openedDialogs: [Dialog] = []

    init() {
        self.storeDialogs.subscribe { [weak self] (result) in
            self?.openedDialogs = result
        }
    }
}
