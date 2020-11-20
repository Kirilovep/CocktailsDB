//
//  Drinks.swift
//  testCoctail
//
//  Created by shizo on 19.11.2020.
//

import Foundation


struct DrinkList: Codable {
    let drinks: [Drink]
}

struct Drink: Codable {
    let strDrink: String
    let strDrinkThumb: String
    let idDrink: String
}

