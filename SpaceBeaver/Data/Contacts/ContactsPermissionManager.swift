//
//  ContactsManager.swift
//  KarmaCall
//
//  Created by Dmytro Kholodov on 14.06.2021.
//

import Contacts
import Combine

class PermissionService: NSObject {

    func askForContactsPermission() -> Future<Bool, Error> {
        return Future { [weak self] promise in

            switch CNContactStore.authorizationStatus(for: .contacts) {
            case .authorized:
                DispatchQueue.main.async {
                    promise(.success(true))
                }
            case .denied:
                DispatchQueue.main.async {
                    promise(.failure(NotGrantedPermission(title: "", description: "")))
                }
            case .restricted, .notDetermined:
                CNContactStore().requestAccess(for: .contacts) { granted, error in
                    if granted {
                        DispatchQueue.main.async {
                            promise(.success(true))
                        }
                    } else {
                        DispatchQueue.main.async {
                            promise(.success(false))
                        }
                    }
                }
            @unknown default:
                DispatchQueue.main.async {
                    promise(.success(false))
                }
            }
        }
    }
}
