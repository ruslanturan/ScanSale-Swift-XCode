//
//  Product.swift
//  ScanSale
//
//  Created by Ruslan Cahangirov on 5/5/20.
//  Copyright © 2020 Ruslan Cahangirov. All rights reserved.
//

import UIKit

class classProduct : Codable{
    var id = 0
    var name = ""
    var cost = 0.0
    var unique = 0
    var baseCount = 0
    var count = 0
    var photo = ""
    init(id: Int, name: String, cost: Double, unique: Int, baseCount: Int, count: Int, photo: String){
        self.id = id
        self.name = name
        self.cost = cost
        self.unique = unique
        self.baseCount = baseCount
        self.count = count
        self.photo = photo
    }
}
