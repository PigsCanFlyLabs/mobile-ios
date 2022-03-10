//
//  Errots.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 10.03.2022.
//

import Foundation

protocol SpaceBeaverErrorProtocol: LocalizedError {
    var code: ErrorCode { get }
    var title: String? { get }
    var description: String { get }
}

struct SpaceBeaverError: SpaceBeaverErrorProtocol {
    let code: ErrorCode
    let title: String? = nil
    let description: String
}


enum ErrorCode {
    // permissions
    case not_granted

}
struct NotGrantedPermission: SpaceBeaverErrorProtocol {
    let code = ErrorCode.not_granted
    let title: String?
    let description: String
}
