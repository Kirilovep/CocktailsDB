//
//  MainTableViewCell.swift
//  testCoctail
//
//  Created by shizo on 19.11.2020.
//

import UIKit
import Kingfisher
class MainTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coctailImageView: UIImageView!
    
    
    
    //MARK: - Functions -
    func configure(_ result: [DrinkList?],indexPath : IndexPath ) {
        
        let drinks = result[indexPath.section]
        let drink = drinks?.drinks[indexPath.row]
        nameLabel.text = drink?.strDrink
        let imageURL = URL(string: drink?.strDrinkThumb ?? " ")
        coctailImageView.kf.indicatorType = .activity
        coctailImageView.kf.setImage(with: imageURL)
        
    }
}
