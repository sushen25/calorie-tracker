//
//  VolumeData.swift
//  Calo Track
//
//  Created by Sushen Satturu on 4/5/2022.
//

import UIKit

class VolumeData: NSObject, Decodable {
    var foods: [FoodData]?
    
    private enum CodingKeys: String, CodingKey {
        case foods = "branded"
    }
}


class FoodData: NSObject, Decodable {
    
    var foodName: String?
    var servingUnit: String?
    var calories: Int?
    var brandName: String?
    var imageUrl: String?
    var nixItemId: String?
    
    
    required init(from decoder: Decoder) throws {
        let foodContainer = try decoder.container(keyedBy: FoodKeys.self)
        let imageContainer = try foodContainer.nestedContainer(keyedBy: ImageKeys.self, forKey: .photo)
        
        foodName = try foodContainer.decode(String.self, forKey: .foodName)
        servingUnit = try foodContainer.decode(String.self, forKey: .servingUnit)
        calories = try? foodContainer.decode(Int.self, forKey: .calories)
        brandName = try foodContainer.decode(String.self, forKey: .brandName)
        nixItemId = try foodContainer.decode(String.self, forKey: .nixItemId)
        
        imageUrl = try imageContainer.decode(String.self, forKey: .imageUrl)
    }
    
    private enum FoodKeys: String, CodingKey {
        case foodName = "food_name"
        case servingUnit = "serving_unit"
        case calories = "nf_calories"
        case brandName = "brand_name"
        case photo
        case nixItemId = "nix_item_id"
    }
    
    private enum ImageKeys: String, CodingKey {
        case imageUrl = "thumb"
    }
    
}
