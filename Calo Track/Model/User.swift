//
//  User.swift
//  Calo Track
//
//  Created by Sushen Satturu on 8/5/2022.
//

import UIKit
import FirebaseFirestoreSwift

class User: NSObject, Codable {
    
    @DocumentID var id: String?
    var name: String?
    var email: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
    }

}
