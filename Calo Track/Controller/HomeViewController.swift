//
//  HomeViewController.swift
//  Calo Track
//
//  Created by Sushen Satturu on 19/4/2022.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController, DatabaseListener {
    var listenerType: ListenerType = .users
    
    var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        databaseController?.signOutUser()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    func onUserChange(change: DatabaseChange) {
        if change == .notAuthenticated {
            databaseController?.removeListener(listener: self)
            // pop 2 view controllers to navigate to the welcome screen
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[0], animated: true)
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
