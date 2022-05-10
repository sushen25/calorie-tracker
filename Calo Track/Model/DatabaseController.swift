//
//  DatabaseController.swift
//  Calo Track
//
//  Created by Sushen Satturu on 8/5/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth

class DatabaseController: NSObject, DatabaseProtocol {
    
    var listeners = MulticastDelegate<DatabaseListener>()

    
    var authController: Auth
    var database: Firestore
    var currentUser: FirebaseAuth.User?
    
    override init() {
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        
        
        super.init()
        
        authController.addStateDidChangeListener() { auth, user in
            if let user = user {
                // Signed in
                self.currentUser = user
                self.listeners.invoke() { listener in
                    if listener.listenerType == .users || listener.listenerType == .all {
                        listener.onUserChange(change: .authenticated)
                    }
                    
                }
            } else {
                // User not signed in
                self.listeners.invoke() { listener in
                    if listener.listenerType == .users || listener.listenerType == .all {
                        listener.onUserChange(change: .notAuthenticated)
                    }
                }
            }
            
        }
        
    }
    
    
    func cleanup() {
        // do nothing TODO - remove
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func signUpUser(email: String, password: String) {
        authController.createUser(withEmail: email, password: password) { (authResult, error) in
            if let errorCreatingUser = error {
                print("error signing in: \(errorCreatingUser.localizedDescription)")
                return
            }
        }
    }
    
    func signInUser(email: String, password: String) {
        authController.signIn(withEmail: email, password: password) { (authResult, error) in
            if let errorCreatingUser = error {
                print("error signing in: \(errorCreatingUser.localizedDescription)")
                return
            }
        }
    }
    
    func signOutUser() {
        do {
            try authController.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        
    }
    
    
}
