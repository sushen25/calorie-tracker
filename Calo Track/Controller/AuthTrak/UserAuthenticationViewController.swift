//
//  UserAuthenticationViewController.swift
//  Calo Track
//
//  Created by Sushen Satturu on 19/4/2022.
//

import UIKit
import FirebaseAuth

class UserAuthenticationViewController: UIViewController, DatabaseListener {
    
    var authenticationType: AuthenticationType?
    var isSignIn: Bool?
    var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    
    var listenerType: ListenerType = .users
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.green

        // Do any additional setup after loading the view.
        isSignIn = authenticationType == .signIn
        
        if isSignIn! {
            self.title = "Sign In"
            actionButton.titleLabel?.text = "Sign In"
        } else {
            self.title = "Sign Up"
            actionButton.titleLabel?.text = "Sign Up"
        }
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            print("Please enter the email and/or password")
            return
        }
        
        if isSignIn! {
            databaseController?.signInUser(email: email, password: password)
        } else {
            databaseController?.signUpUser(email: email, password: password)
        }
        
    }
    
    // MARK: - Listeners
    func onUserChange(change: DatabaseChange) {
        databaseController?.removeListener(listener: self)
        
        if change == .authenticated {
            self.performSegue(withIdentifier: "authenticatedSegue", sender: nil)
        }
    }
    
    func onFoodListChange(change: DatabaseChange, foodList: [[String: Any]]) {
        // Do nothing
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
