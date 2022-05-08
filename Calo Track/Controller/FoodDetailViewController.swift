//
//  FoodDetailViewController.swift
//  Calo Track
//
//  Created by Sushen Satturu on 7/5/2022.
//

import UIKit

class FoodDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var indicator = UIActivityIndicatorView(style: .large)
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodTitleLabel: UILabel!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    
    
    @IBOutlet weak var numberOfServingsTextField: UITextField!
    @IBOutlet weak var mealPicker: UIPickerView!
    
    var selectedFood: FoodData?
    var servingSize: Int?
    
    var mealPickerData: [String] = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        numberOfServingsTextField.keyboardType = .numberPad
        
        // Picker views
        mealPicker.delegate = self
        mealPicker.dataSource = self

        
        mealPickerData = ["breakfast", "lunch", "dinner", "snacks"]
        
        print(selectedFood!.nixItemId)
        
        // Add a loading indicator view
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        indicator.startAnimating()
        // Make call to food detail api
        Task {
            await requestFoodNutrition((selectedFood?.nixItemId)!)
        }
        
    }
    
    // MARK: - Picker view methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == mealPicker {
            return mealPickerData.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == mealPicker {
            return mealPickerData[row]
        }
        
        return nil
    }
    
    func setFoodDetails(foodDetailData: FoodDetailData?) {
        guard let data = foodDetailData else {
            print("No food detail data")
            return
        }
        
        foodTitleLabel.text = selectedFood?.foodName
        brandNameLabel.text = selectedFood?.brandName
        
        proteinLabel.text = "\(data.protein!)g Protein"
        carbsLabel.text = "\(data.carbs!)g Carbs"
        fatLabel.text = "\(data.fat!)g Fat"
        
    }
    
    
    // MARK: - API Methods
    func requestFoodNutrition(_ nixItemId: String) async {
        var searchURLComponents = URLComponents()
        searchURLComponents.scheme = "https"
        searchURLComponents.host = "trackapi.nutritionix.com"
        searchURLComponents.path = "/v2/search/item"
        
        searchURLComponents.queryItems = [
            URLQueryItem(name: "nix_item_id", value: nixItemId)
        ]
        
        guard let requestUrl = searchURLComponents.url else {
            print("Invalid Item Search URL")
            return
        }
        
        // make a struct ApiKey and define API KEYS
        let headers = ["x-app-id":ApiKeys.X_APP_ID, "x-app-key":ApiKeys.X_APPLICATION_KEY, "x-remote-user-id":"0"]
        var urlRequest = URLRequest(url: requestUrl)
        
        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            print(String(decoding: data, as: UTF8.self))
            
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }

            
            let decoder = JSONDecoder()
            let volumeData = try decoder.decode(VolumeFoodDetailData.self, from: data)
            
            setFoodDetails(foodDetailData: volumeData.foods?.first)
            
        } catch let error {
            print(error)
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
