//
//  FilterViewController.swift
//  testCoctail
//
//  Created by shizo on 20.11.2020.
//

import UIKit

class FilterViewController: UIViewController {
    
    //MARK: - Properties -
    var categoryList: Categories?
    var currentCategoryList: Categories?
    weak var delegate : MainViewControllerDelegate?
    
    //MARK: - IBOutlets -
    @IBOutlet weak var filterTableView: UITableView! {
        didSet {
            filterTableView.delegate = self
            filterTableView.dataSource = self
            let nib = UINib(nibName: TableViewCells.filterTableViewNibName.rawValue, bundle: nil)
            filterTableView.register(nib, forCellReuseIdentifier: TableViewCells.filterTableViewCell.rawValue)
            filterTableView.tableFooterView = UIView()
            filterTableView.rowHeight = 65
            filterTableView.separatorStyle = .none
        }
    }
    
    //MARK: - LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false

    }
    
    //MARK: - IBActions -
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        self.delegate?.update(self.currentCategoryList)
        navigationController?.popViewController(animated: true)
    }
}

    //MARK: - Extensions -
extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.category.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCells.filterTableViewCell.rawValue) as! FilterTableViewCell
        cell.configure(categories: categoryList!, indexPath: indexPath, currentCategories: currentCategoryList!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let currentCategory = currentCategoryList?.category else { return }
        if currentCategory.count - 1 == 0 {
            if currentCategory.first == categoryList?.category[indexPath.row] {
                return
            }
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! FilterTableViewCell
        if cell.checkImageView.isHidden {
            guard let category = categoryList?.category[indexPath.row] else { return }
            currentCategoryList?.category.append(category)
        } else {
            guard let category = categoryList?.category[indexPath.row] else { return }
            if let index = currentCategoryList?.category.firstIndex(of: category) {
                currentCategoryList?.category.remove(at: index)
            }
        }
        cell.checkImageView.isHidden = !cell.checkImageView.isHidden
    }
    
}
