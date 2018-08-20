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
    var newItem = Item()
    
    var selectedDate: String?
    
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
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableCell", for: indexPath)
        cell = UITableViewCell(style: .value1, reuseIdentifier: "ItemTableCell")

        if let item = storeItems?[indexPath.row] {
            cell.textLabel?.text = item.item
            cell.detailTextLabel?.text = String(item.amount)
        }
        
        return cell
    }
    
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    // MARK: - Add New Items
    
    @IBAction func retreiveNewItem(segue: UIStoryboardSegue) {
        
        if let currentStore = selectedStore {
            do {
                try realm.write {
                    currentStore.items.append(newItem)
                }
            } catch {
                print("Error saving new items, \(error)")
            }
        }
        print("tableView.reloadData()")
        tableView.reloadData()
        newItem = Item()
    }
    
    
    // MARK: - Data Manipulation Methods
    
    func loadItems() {
        
        storeItems = selectedStore?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
    }
    
}
