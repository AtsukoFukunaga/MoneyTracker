//
//  StoreViewController.swift
//  MoneyTracker
//
//  Created by Atsuko Fukunaga on 8/12/18.
//  Copyright © 2018 Atsuko Fukunaga. All rights reserved.
//

import UIKit
import RealmSwift

class StoreViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var storeArray: Results<Store>?
    
    var selectedDate: String? {
        didSet{
            loadStores()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    // MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return storeArray?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTableCell", for: indexPath)
        cell.textLabel?.text = storeArray?[indexPath.row].storeName ?? "No stores added yet"
        
        return cell
        
    }
    
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ItemViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedStore = storeArray?[indexPath.row]
        }
    }
    
    
    // MARK: - Add New Stores
    
    @IBAction func addStoreButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Store", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Store", style: .default) { (action) in
            
            let newStore = Store()
            newStore.storeName = textField.text!
            newStore.shoppingDate = self.selectedDate!
            
            self.saveStores(store: newStore)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Model Manupulation Methods
    
    func saveStores(store: Store) {

        do {
            try realm.write {
                realm.add(store)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    func loadStores() {
        
        storeArray = realm.objects(Store.self).filter("shoppingDate == %@", selectedDate!)
        
    }

}
