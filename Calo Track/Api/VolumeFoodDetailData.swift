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
    var protein: Int?
    var carbs: Int?
    var fat: Int?
    var calories: Int?
    var sugars: Int?
    
    required init(from decoder: Decoder) throws {
        let foodDetailContainer = try decoder.container(keyedBy: FoodDetailKeys.self)
        
        servingQty = try? foodDetailContainer.decode(String.self, forKey: .servingQty)
        servingUnit = try foodDetailContainer.decode(String.self, forKey: .servingUnit)
        protein = try foodDetailContainer.decode(Int.self, forKey: .protein)
        carbs = try foodDetailContainer.decode(Int.self, forKey: .carbs)
        fat = try foodDetailContainer.decode(Int.self, forKey: .fat)
        calories = try foodDetailContainer.decode(Int.self, forKey: .calories)
    }
    
    
    private enum FoodDetailKeys: String, CodingKey {
        case servingQty = "serving_qty"
        case servingUnit = "serving_unit"
        case protein = "nf_protein"
        case carbs = "nf_total_carbohydrate"
        case fat = "nf_total_fat"
        case calories = "nf_calories"
        case sugars = "nf_sugars"
    }
}
