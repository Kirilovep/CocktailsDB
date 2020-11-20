//
//  Categories.swift
//  testCoctail
//
//  Created by shizo on 20.11.2020.
//

import Foundation

struct CategoryList: Codable {
    let drinks: [Category]
}

struct Category: Codable {
    let strCategory: String
}

struct Categories {
    var category: [String]
}
