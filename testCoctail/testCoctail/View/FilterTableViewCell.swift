//
//  FilterTableViewCell.swift
//  testCoctail
//
//  Created by shizo on 20.11.2020.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    
    //MARK: - Functions - 
    func configure(categories: Categories, indexPath: IndexPath, currentCategories: Categories) {
        let category = categories.category[indexPath.row]
        if currentCategories.category.contains(category) {
            checkImageView.isHidden = false
        } else {
            checkImageView.isHidden = true
        }
        filterLabel.text = categories.category[indexPath.row]
        
    }
    
}
