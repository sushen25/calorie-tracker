//
//  DatabaseProtocol.swift
//  Calo Track
//
//  Created by Sushen Satturu on 19/4/2022.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onUserChange(change: DatabaseChange)
}
