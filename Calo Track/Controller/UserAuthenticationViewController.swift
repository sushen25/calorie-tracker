//
//  UserAuthenticationViewController.swift
//  Calo Track
//
//  Created by Sushen Satturu on 19/4/2022.
//

import UIKit
import FirebaseAuth

class UserAuthenticationViewController: UIViewController {
    
    var authenticationType: AuthenticationType?
    var isSignIn: Bool?
    var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            print("Please enter the email and/or password")
            return
        }
        
        if isSignIn! {
            print("Signing In \(email)")
            let _ = databaseController?.signInUser(email: email, password: password)
            
            // TODO - check if user is succesfully signed in
//            self.performSegue(withIdentifier: "authenticatedSegue", sender: nil)
        } else {
            // Sign Up
            print("Signing Up \(email)")
//            firebaseAuth?.createUser(withEmail: email, password: password) { (authResult, error) in
//                if let errorCreatingUser = error {
//                    print("error creating user: \(errorCreatingUser.localizedDescription)")
//                } else if let result = authResult {
//                    print(result)
//                }
//            }
        }
        
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
