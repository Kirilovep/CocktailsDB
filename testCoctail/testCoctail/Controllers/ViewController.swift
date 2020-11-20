//
//  ViewController.swift
//  testCoctail
//
//  Created by shizo on 19.11.2020.
//

import UIKit

protocol MainViewControllerDelegate: class {
    func update(_ categories : Categories?)
}

class ViewController: UIViewController, MainViewControllerDelegate {
    
    //MARK: - Properties -
    var categoryList: Categories?
    var currentCategoryList : Categories?
    var networkManager = NetworkManager()
    private var drinkList = [DrinkList]()
    private var newDrinkList = [DrinkList]()
    private var index = 0 
    private var maxIndex = 0
    
    //MARK: - IBOutlets -
    @IBOutlet weak var filterOutlet: UIBarButtonItem!
    @IBOutlet weak var mainTableView: UITableView! {
        didSet {
            mainTableView.delegate = self
            mainTableView.dataSource = self
            let nib = UINib(nibName: TableViewCells.mainTableViewNibName.rawValue, bundle: nil)
            mainTableView.register(nib, forCellReuseIdentifier: TableViewCells.mainTableViewCell.rawValue)
            mainTableView.rowHeight = 130
            mainTableView.tableFooterView = UIView()
            mainTableView.separatorStyle = .none
        }
    }
    //MARK: - LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDrinks()
        loadCategories()
    }
    
    //MARK: - IBActions -
    @IBAction func filterButtonTapped(_ sender: UIBarButtonItem) {
        let desVC = storyboard?.instantiateViewController(withIdentifier: identifierVC.filterVCName.rawValue) as! FilterViewController
        desVC.categoryList = categoryList
        desVC.currentCategoryList = currentCategoryList
        desVC.delegate = self
        navigationController?.pushViewController(desVC, animated: true)
        
    }
    
    //MARK: - Private Func -
    private func loadCategories() {
        networkManager.getCategories { [weak self] (categories) in
            DispatchQueue.main.async {
                self?.categoryList = categories
                self?.currentCategoryList = categories
                self?.maxIndex = categories.category.count
                self?.getDrinks()
            }
        }
    }
    
    private func getDrinks() {
        guard index < maxIndex else {return}
        let category = currentCategoryList?.category[index] ?? ""
        let replaceCategory = category.replacingOccurrences(of: " ", with: "_")
        networkManager.loadAllDrinks(replaceCategory) { [weak self] (drinks) in
            DispatchQueue.main.async {
                self?.newDrinkList.append(drinks)
                self?.mainTableView.reloadData()
            }
        }
    }
    
    func update(_ categories: Categories?) {
        currentCategoryList = categories
        drinkList = []
        newDrinkList = []
        index = 0
        maxIndex = currentCategoryList?.category.count ?? 1
        getDrinks()
    }
    
    @objc func loadNewDrinks() {
        getDrinks()
    }
}

//MARK: - Extensions -
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return newDrinkList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        setViewForHeader(tableView: tableView, section: section)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newDrinkList[section].drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCells.mainTableViewCell.rawValue) as! MainTableViewCell
        cell.configure(newDrinkList, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == newDrinkList.count - 1 {
            if indexPath.row == newDrinkList[indexPath.section].drinks.count - 1 {
                index = index + 1
                perform(#selector(loadNewDrinks))
            }
        }
    }
}

extension ViewController {
    
    func setViewForHeader(tableView: UITableView,section: Int) -> UIView {
        let newHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
        let newLabel = UILabel()
        newLabel.frame = CGRect(x: 15, y: 5, width: newHeaderView.frame.width - 10, height: 20)
        newHeaderView.backgroundColor = .white
        guard let newSection = currentCategoryList?.category[section] else { return UIView() }
        newLabel.text = newSection
        newLabel.textColor = .darkGray
        newHeaderView.addSubview(newLabel)
        return newHeaderView
    }
}
