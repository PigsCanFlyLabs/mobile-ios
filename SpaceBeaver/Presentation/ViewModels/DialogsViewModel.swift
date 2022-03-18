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
    var fetchedDialogs: [Dialog]? = nil

    private var subscribed = true

    init() {
        self.storeDialogs.subscribe { [weak self] (result) in
            if self?.subscribed ?? true {
                self?.openedDialogs = result
            } else {
                self?.fetchedDialogs = result
            }
        }
    }

    func subscribe() {
        subscribed = true
        if let prefetched = fetchedDialogs {
            openedDialogs = prefetched
            fetchedDialogs = nil
        }
    }
    func unsubscribe() {
        subscribed = false
    }

}
