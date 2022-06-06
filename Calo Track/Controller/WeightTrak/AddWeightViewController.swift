//
//  AddWeightViewController.swift
//  Calo Track
//
//  Created by Sushen Satturu on 6/6/2022.
//

import UIKit


class AddWeightViewController: UIViewController {
    
    var databaseController: DatabaseProtocol?
    
    
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var weightDatePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        weightDatePicker.maximumDate = Date()
    }
    
    @IBAction func saveWeightData(_ sender: Any) {
        guard let weightText = weightTextField.text, let weight = Double(weightText) else {
            return
        }
        
        databaseController?.addWeight(weight: weight, date: weightDatePicker.date)
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
