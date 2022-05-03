//
//  WelcomeViewController.swift
//  Calo Track
//
//  Created by Sushen Satturu on 19/4/2022.
//

import UIKit

enum AuthenticationType {
    case signIn
    case signUp
}

class WelcomeViewController: UIViewController {
    
    let USER_AUTH_SEGUE: String = "userAuthenticatonSegue"
    var authenticationType: AuthenticationType?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logIn(_ sender: Any) {
        authenticationType = .signIn
        performSegue(withIdentifier: USER_AUTH_SEGUE, sender: nil)
    }
    
    @IBAction func signIn(_ sender: Any) {
        authenticationType = .signUp
        performSegue(withIdentifier: USER_AUTH_SEGUE, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == USER_AUTH_SEGUE {
            let destination = segue.destination as! UserAuthenticationViewController
            destination.authenticationType = authenticationType
        }
    }

}
