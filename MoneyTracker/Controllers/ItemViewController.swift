//
//  ItemViewController.swift
//  MoneyTracker
//
//  Created by Atsuko Fukunaga on 8/12/18.
//  Copyright © 2018 Atsuko Fukunaga. All rights reserved.
//

import UIKit
import CoreData

class ItemViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedStore: Store? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].item
        var amount: Double = 0.00
        if itemArray[indexPath.row].expense != 0 {
            amount = itemArray[indexPath.row].expense
        } else {
            amount = itemArray[indexPath.row].income
        }
        cell.detailTextLabel?.text = String(amount)
        
        return cell
    }
    
    
    // MARK: - TableView Delegate Methods
    
    
    // MARK: - Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.item = alert.textFields![0].text
            newItem.expense = Double(alert.textFields![1].text!)! * -1.00
            newItem.income = Double(alert.textFields![2].text!)! * 1.00
            newItem.parentCategory = self.selectedStore
            
            self.itemArray.append(newItem)
            self.saveItems()
            
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
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        let predicate = NSPredicate(format: "parenetCategory.storeName MATCHES %@", selectedStore!.items!)
        request.predicate = predicate
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
}
