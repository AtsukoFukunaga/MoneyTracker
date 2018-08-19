//
//  AddItemsViewController.swift
//  MoneyTracker
//
//  Created by Atsuko Fukunaga on 8/18/18.
//  Copyright © 2018 Atsuko Fukunaga. All rights reserved.
//

import UIKit

class AddItemsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let categories: Array = ["Personal", "Work", "Auto"]
    let subcategories: Array = ["Shopping", "Computer", "Dining", "Field", "Travel", "Gas", "Maintainance"]

    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var subcategoryPicker: UIPickerView!
    @IBOutlet weak var amount: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        subcategoryPicker.delegate = self
        subcategoryPicker.dataSource = self
        
    }

    // MARK: - PickerView Datasource Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return categories.count
        } else {
            return subcategories.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return categories[row]
        } else {
            return subcategories[row]
        }
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ItemViewController
        
        destinationVC.loadItems()

    }

}
