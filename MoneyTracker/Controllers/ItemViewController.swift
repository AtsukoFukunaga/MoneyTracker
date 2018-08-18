//
//  ItemViewController.swift
//  MoneyTracker
//
//  Created by Atsuko Fukunaga on 8/12/18.
//  Copyright © 2018 Atsuko Fukunaga. All rights reserved.
//

import UIKit
import RealmSwift

class ItemViewController: UITableViewController {
    
    var storeItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedStore: Store? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return storeItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableCell", for: indexPath)
        
        if let item = storeItems?[indexPath.row] {
            cell.textLabel?.text = item.item
            var amount: Int = 0
            if item.expense != 0 {
                amount = item.expense
            } else {
                amount = item.income
            }
            cell.detailTextLabel?.text = String(amount)
        }
        
        return cell
    }
    
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    // MARK: - Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentStore = self.selectedStore {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.dateCreated = Date()
                        newItem.item = alert.textFields![0].text!
                        newItem.expense = Int(alert.textFields![1].text!)! * -1
                        newItem.income = Int(alert.textFields![2].text!)!
                        currentStore.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (alertTextField: UITextField) in
            alertTextField.placeholder = "Create new item"
        }
        alert.addTextField { (alertTextField: UITextField) in
            alertTextField.keyboardType = .numberPad
            alertTextField.placeholder = "0"
        }
        alert.addTextField { (alertTextField: UITextField) in
            alertTextField.keyboardType = .numberPad
            alertTextField.placeholder = "0"
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Data Manipulation Methods
    
    func loadItems() {
        
        storeItems = selectedStore?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
    }
    
}
