//
//  DialogsViewModel.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 04.03.2022.
//

import Foundation

class DialogsViewModel: ObservableObject {

    static let shared = DialogsViewModel()

    @Published var openedDialogs: [Dialog] = [Dialog.dummy1, Dialog.dummy2, Dialog.dummy3]
}
