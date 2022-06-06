//
//  VolumeFoodDetailData.swift
//  Calo Track
//
//  Created by Sushen Satturu on 8/5/2022.
//

import UIKit

class VolumeFoodDetailData: NSObject, Decodable {
    var foods: [FoodDetailData]?
    
    private enum CodingKeys: String, CodingKey {
        case foods = "foods"
    }
}

class FoodDetailData: NSObject, Decodable {
    
    var servingQty: String?
    var servingUnit: String?
    var protein: Double?
    var carbs: Double?
    var fat: Double?
    var calories: Double?
    
    var proteinInt: Int? {
        guard let protein = protein else {
            return nil
        }
        return Int(protein)
    }
    var carbsInt: Int? {
        guard let carbs = carbs else {
            return nil
        }
        return Int(carbs)
    }
    
    var fatInt: Int? {
        guard let fat = fat else {
            return nil
        }
        return Int(fat)
    }
    
    required init(from decoder: Decoder) throws {
        let foodDetailContainer = try decoder.container(keyedBy: FoodDetailKeys.self)
        
        servingQty = try? foodDetailContainer.decode(String.self, forKey: .servingQty)
        servingUnit = try foodDetailContainer.decode(String.self, forKey: .servingUnit)
        protein = try foodDetailContainer.decode(Double.self, forKey: .protein)
        carbs = try foodDetailContainer.decode(Double.self, forKey: .carbs)
        fat = try foodDetailContainer.decode(Double.self, forKey: .fat)
        calories = try foodDetailContainer.decode(Double.self, forKey: .calories)
    }
    
    
    private enum FoodDetailKeys: String, CodingKey {
        case servingQty = "serving_qty"
        case servingUnit = "serving_unit"
        case protein = "nf_protein"
        case carbs = "nf_total_carbohydrate"
        case fat = "nf_total_fat"
        case calories = "nf_calories"
    }
}
