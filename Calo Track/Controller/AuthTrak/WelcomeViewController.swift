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

class WelcomeViewController: UIViewController, DatabaseListener {
    
    var indicator = UIActivityIndicatorView(style: .large)
    
    let USER_AUTH_SEGUE: String = "userAuthenticatonSegue"
    let USER_AUTHENTICATED_SEGUE: String = "userAuthenticatedSegue"
    var authenticationType: AuthenticationType?
    var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = ListenerType.users

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        // Add a loading indicator view
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        indicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
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
    
    func onUserChange(change: DatabaseChange) {
        // Do not listen to any further updates for user
        databaseController?.removeListener(listener: self)
        
        if change == .authenticated {
            print("User already signed In, navigating to home page")
            self.indicator.stopAnimating()
            performSegue(withIdentifier: USER_AUTHENTICATED_SEGUE, sender: nil)
        } else if change == .notAuthenticated {
            self.indicator.stopAnimating()
        }
    }
    
    func onFoodListChange(change: DatabaseChange, foodList: [[String: Any]]) {
        // Do nothing
    }

}
