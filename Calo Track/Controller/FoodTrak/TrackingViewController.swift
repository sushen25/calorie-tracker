//
//  TrackingViewController.swift
//  Calo Track
//
//  Created by Sushen Satturu on 4/5/2022.
//

import UIKit

class TrackingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DatabaseListener {
    
    var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .users
    
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
    
    var foodItems: [[String: Any]] = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        // addTestItems()
        

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        databaseController?.addListener(listener: self)
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
    
    @IBAction func tempGetFoodsButton(_ sender: Any) {
        let _ = databaseController?.getMealsForDate(Date.now)
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
    
    //MARK: - methods
    func convertFoodListToTableData() {
        self.resetFoodLists()
        
        var totalProtein: Int = 0
        var totalCarbs: Int = 0
        var totalFat: Int = 0
        var totalCalories: Int = 0
        
        for food in foodItems {
            let meal = food["meal"] as! String
            let foodName = food["foodName"] as! String
            
            if (meal == "breakfast") {
                self.breakfastItems.append(foodName)
            } else if (meal == "lunch") {
                self.lunchItems.append(foodName)
            } else if (meal == "dinner") {
                self.dinnerItems.append(foodName)
            } else if (meal == "snack") {
                self.snackItems.append(foodName)
            }
            
            totalProtein += food["protein"] as! Int
            totalCarbs += food["carbs"] as! Int
            totalFat += food["fat"] as! Int
            totalCalories += food["totalCalories"] as! Int
            
        }
        
        self.setSummaryLabels(protein: totalProtein, carbs: totalCarbs, fat: totalFat, calories: totalCalories)
        tableView.reloadData()
    }
    
    func resetFoodLists() {
        self.breakfastItems.removeAll()
        self.lunchItems.removeAll()
        self.dinnerItems.removeAll()
        self.snackItems.removeAll()
    }
    
    func setSummaryLabels(protein: Int, carbs: Int, fat: Int, calories: Int) {
        self.proteinLabel.text = "\(protein)g"
        self.carbsLabel.text = "\(carbs)g"
        self.fatLabel.text = "\(fat)g"
        self.caloriesLabel.text = "\(calories)"
    }
    
    //  MARK: - listeners
    func onUserChange(change: DatabaseChange) {
        // Do nothing
    }
    
    func onFoodListChange(change: DatabaseChange, foodList: [[String : Any]]) {
        foodItems = foodList
        self.convertFoodListToTableData()
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
