//
//  DatabaseProtocol.swift
//  Calo Track
//
//  Created by Sushen Satturu on 19/4/2022.
//

import Foundation
import FirebaseAuth

enum DatabaseChange {
    case add
    case remove
    case update
    case authenticated
    case notAuthenticated
}

enum ListenerType {
    case all
    case users
}

// TODO - ask tutor about separating listeners into sub listener (eg. UserDatabaseListener etc.)
protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onUserChange(change: DatabaseChange)
    func onFoodListChange(change: DatabaseChange, foodList: [[String: Any]])
}


protocol DatabaseProtocol: AnyObject {
    var currentUser: FirebaseAuth.User? { get set }
    
    func cleanup()
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
    func signUpUser(email: String, password: String)
    func signInUser(email: String, password: String)
    func signOutUser()
    
    func addMeal(_ data: [String: Any])
    func getMealsForDate(_ date: Date) -> [String: Any]
}
