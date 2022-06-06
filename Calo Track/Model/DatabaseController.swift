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

extension CollectionReference {
    func whereField(_ field: String, isDateInToday value: Date) -> Query {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: value)
        guard
            let start = Calendar.current.date(from: components),
            let end = Calendar.current.date(byAdding: .day, value: 1, to: start)
        else {
            fatalError("Could not find start date or calculate end date.")
        }
        return whereField(field, isGreaterThan: start).whereField(field, isLessThan: end)
    }
}

class DatabaseController: NSObject, DatabaseProtocol {
    
    var listeners = MulticastDelegate<DatabaseListener>()

    
    var authController: Auth
    var database: Firestore
    var currentUser: FirebaseAuth.User?
    var currentFoodList: [[String: Any]]
    
    override init() {
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        currentFoodList = [[String: Any]]()
        
        super.init()
        
        authController.addStateDidChangeListener() { auth, user in
            if let user = user {
                // Signed in
                self.currentUser = user
                print("USER SIGNED IN")
                self.listeners.invoke() { listener in
                    if listener.listenerType == .users || listener.listenerType == .all {
                        listener.onUserChange(change: .authenticated)
                    }
                    
                }
            } else {
                // User not signed in
                self.currentUser = nil
                print("USER NOT SIGNED IN")
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
    
    // MARK: - User
    
    func signUpUser(email: String, password: String) {
        authController.createUser(withEmail: email, password: password) { (authResult, error) in
            if let errorCreatingUser = error {
                print("error signing in: \(errorCreatingUser.localizedDescription)")
                return
            }
            
            // Assume successful sign up here
            if let user = self.currentUser {
                self.database.collection("User").document(user.uid).setData([
                    "email": user.email!
                ])
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
    
    // MARK: - User Food
    func addMeal(_ data: [String: Any]) {
        if let user = currentUser {
            var ref: DocumentReference?
            ref = database.collection("User").document(user.uid).collection("Food").addDocument(data: data) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Food added with ID: \(ref!.documentID)")
                }
            }
            return
        }
        
        print("Error: User not logged in! Cannot add meal")
        
    }
    
    func getMealsForDate(_ date: Date) -> [String: Any] {
        
        if let user = currentUser {
            database.collection("User").document(user.uid).collection("Food").whereField("timeAdded", isDateInToday: date)
                .getDocuments() { (querySnapshot, err) in
                    
                if let err = err {
                    print("Error retreiving foods for date \(date)")
                    print(err)
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        self.currentFoodList.append(document.data())
                    }
                    
                    self.listeners.invoke() { listener in
                        if listener.listenerType == .users || listener.listenerType == .all {
                            listener.onFoodListChange(change: .update, foodList: self.currentFoodList)
                        }
                    }
                }
                
                    
            }
        }
        
        
        return ["lol": 1]
    }
    
}
