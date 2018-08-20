//
//  AddItemsViewController.swift
//  MoneyTracker
//
//  Created by Atsuko Fukunaga on 8/18/18.
//  Copyright © 2018 Atsuko Fukunaga. All rights reserved.
//

import UIKit

class AddItemsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let expenseCategories: Dictionary = ["Personal": ["Shopping", "Computer", "Dining"],
                                         "Work": ["Field", "Travel"],
                                         "Auto": ["Gas", "Maintainance"]]
    let incomeCategories: Dictionary = ["Salary": ["Hubby", "Wift"],
                                        "Misc.": ["Misc."]]
    
    var listOfExCat: [String] = [String]()
    var listOfExSubcat: [String] = [String]()
    var listOfInCat: [String] = [String]()
    var listOfInSubcat: [String] = [String]()
    var selectedCategory: String = ""
    var selectedSubcategory: String = ""
    
    @IBOutlet weak var switchInEx: UISegmentedControl!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var subcategoryPicker: UIPickerView!
    @IBOutlet weak var items: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        subcategoryPicker.delegate = self
        subcategoryPicker.dataSource = self
        
        listOfExCat = Array(expenseCategories.keys)
        if let expenseSubcategories = expenseCategories[listOfExCat[0]] {
            listOfExSubcat = expenseSubcategories
        } else {
            listOfExSubcat = [""]
        }
        
        listOfInCat = Array(incomeCategories.keys)
        if let incomeSubcategories = incomeCategories[listOfInCat[0]] {
            listOfInSubcat = incomeSubcategories
        } else {
            listOfInSubcat = [""]
        }
    }

    
    // MARK: - PickerView Datasource Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if switchInEx.selectedSegmentIndex == 0 && pickerView.tag == 1 {
            return listOfExCat.count
        }
        if switchInEx.selectedSegmentIndex == 0 && pickerView.tag == 2 {
            return listOfExSubcat.count
        }
        if switchInEx.selectedSegmentIndex == 1 && pickerView.tag == 1 {
            return listOfInCat.count
        }
        if switchInEx.selectedSegmentIndex == 1 && pickerView.tag == 2 {
            return listOfInSubcat.count
        } else {
            return 1
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if switchInEx.selectedSegmentIndex == 0 && pickerView.tag == 1 {
            return listOfExCat[row]
        }
        if switchInEx.selectedSegmentIndex == 0 && pickerView.tag == 2 {
            return listOfExSubcat[row]
        }
        if switchInEx.selectedSegmentIndex == 1 && pickerView.tag == 1 {
            return listOfInCat[row]
        }
        if switchInEx.selectedSegmentIndex == 1 && pickerView.tag == 2 {
            return listOfInSubcat[row]
        } else {
            return ""
        }
        
    }

    
    // MARK: - Update Subcategory pickers
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if switchInEx.selectedSegmentIndex == 0 && pickerView.tag == 1 {
            selectedCategory = listOfExCat[row]
            if let expenseSubcategories = expenseCategories[selectedCategory] {
                listOfExSubcat = expenseSubcategories
            } else {
                listOfExSubcat = [""]
            }
            subcategoryPicker.reloadAllComponents()
            selectedSubcategory = listOfExSubcat[0]
        }
        if switchInEx.selectedSegmentIndex == 1 && pickerView.tag == 1 {
            selectedCategory = listOfInCat[row]
            if let incomeSubcategories = incomeCategories[selectedCategory] {
                listOfInSubcat = incomeSubcategories
            } else {
                listOfInSubcat = [""]
            }
            subcategoryPicker.reloadAllComponents()
            selectedSubcategory = listOfInSubcat[0]
        }
        if switchInEx.selectedSegmentIndex == 0 && pickerView.tag == 2 {
            selectedSubcategory = listOfExSubcat[row]
        }
        if switchInEx.selectedSegmentIndex == 1 && pickerView.tag == 2 {
            selectedSubcategory = listOfInSubcat[row]
        }
    }
    
    
    // MARK: - Update Category and Subcategory pickers when segment is changed
    @IBAction func segmentChanged(_ sender: Any) {
        
        categoryPicker.reloadAllComponents()
        subcategoryPicker.reloadAllComponents()
        
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ItemViewController
        
        destinationVC.newItem.dateCreated = Date()
        destinationVC.newItem.category = selectedCategory
        destinationVC.newItem.subcategory = selectedSubcategory
        destinationVC.newItem.item = items.text!
        if switchInEx.selectedSegmentIndex == 0 {
            if let payAmount = Int(amount.text!) {
                destinationVC.newItem.amount = payAmount * -1
            } else {
                destinationVC.newItem.amount = 0
            }
        }
        if switchInEx.selectedSegmentIndex == 1 {
            if let inAmount = Int(amount.text!) {
                destinationVC.newItem.amount = inAmount
            } else {
                destinationVC.newItem.amount = 0
            }
        }
        destinationVC.loadItems()
    }
    
}
