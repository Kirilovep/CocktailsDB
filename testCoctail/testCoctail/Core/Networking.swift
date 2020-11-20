//
//  Networking.swift
//  testCoctail
//
//  Created by shizo on 19.11.2020.
//

import Foundation

class NetworkManager {
    
    
    func loadAllDrinks(_ category: String,_ completionHandler: @escaping (DrinkList) -> Void ) {
        if let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\(category)"){
            URLSession.shared.dataTask(with: url) { (data, responce, error ) in
                if error != nil {
                    print("error in request")
                } else {
                    if let resp = responce as? HTTPURLResponse,
                       resp.statusCode == 200,
                       let responceData = data {
                        let decoder = JSONDecoder()
                        let results = try? decoder.decode(DrinkList.self, from: responceData)
                        if let drinks = results {
                            completionHandler(drinks)
                        }  
                    }
                }
            }.resume()
        }
    }
    
    
    func getCategories(categories: @escaping (Categories) -> Void) {
        if let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list") {
            URLSession.shared.dataTask(with: url) { (data, responce , error ) in
                if error != nil {
                    print("error in request")
                } else {
                    if let resp = responce as? HTTPURLResponse,
                       resp.statusCode == 200,
                       let responceData = data {
                        let decoder = JSONDecoder()
                        let results = try? decoder.decode(CategoryList.self, from: responceData)
                        if let newResults = results {
                            categories(self.setCategories(categoryList: newResults))
                        }
                    }
                      
                }
            }.resume()
        }
    }
    func setCategories(categoryList: CategoryList) -> Categories {
        var categories = [String]()
        for category in categoryList.drinks{
            categories.append(category.strCategory)
        }
        return Categories(category: categories)
    }
    
}
