//
//  TrackingViewController.swift
//  Calo Track
//
//  Created by Sushen Satturu on 4/5/2022.
//

import UIKit

class TrackingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let SECTION_BREAKFAST = 0
    let SECTION_LUNCH = 1
    let SECTION_DINNER = 2
    let SECTION_SNACK = 3
    
    let CELL_FOOD = "foodCell"
    
    var breakfastItems: [String] = [String]()
    var lunchItems: [String] = [String]()
    var dinnerItems: [String] = [String]()
    var snackItems: [String] = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTestItems()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    // MARK: - Table View Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case SECTION_LUNCH:
                return lunchItems.count
            case SECTION_DINNER:
                return dinnerItems.count
            case SECTION_SNACK:
                return snackItems.count
            default:
                return breakfastItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let foodCell = tableView.dequeueReusableCell(withIdentifier: CELL_FOOD, for: indexPath)
        
        var cellText: String = ""
        switch indexPath.section {
            case SECTION_LUNCH:
                cellText = lunchItems[indexPath.row]
            case SECTION_DINNER:
                cellText = dinnerItems[indexPath.row]
            case SECTION_SNACK:
                cellText = snackItems[indexPath.row]
            default:
                cellText = breakfastItems[indexPath.row]
        }
        
        foodCell.textLabel!.text = cellText
        
        return foodCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case SECTION_LUNCH:
                return "Lunch"
            case SECTION_DINNER:
                return "Dinner"
            case SECTION_SNACK:
                return "Snacks"
            default:
                return "Breakfast"
        }
    }
    
    
    func addTestItems() {
        breakfastItems.append("Nutrigrain")
        breakfastItems.append("Milk")
        
        lunchItems.append("Chicken Breast")
        lunchItems.append("Rice")
        
        dinnerItems.append("Turkey Mince")
        dinnerItems.append("Brown Rice")
        
        snackItems.append("Up and Go")
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
