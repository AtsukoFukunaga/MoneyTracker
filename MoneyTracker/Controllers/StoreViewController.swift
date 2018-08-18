//
//  StoreViewController.swift
//  MoneyTracker
//
//  Created by Atsuko Fukunaga on 8/12/18.
//  Copyright © 2018 Atsuko Fukunaga. All rights reserved.
//

import UIKit
import CoreData

class StoreViewController: UITableViewController {
    
    var storeArray = [Store]()
    
    var selectedDate: Date? {
        didSet{
            loadStores()
        }
    }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }


    // MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return storeArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTableCell", for: indexPath)
        cell.textLabel?.text = storeArray[indexPath.row].storeName
        
        return cell
        
    }
    
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
//        context.delete(storeArray[indexPath.row])
//        storeArray.remove(at: indexPath.row)
//
//        saveStores()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ItemViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedStore = storeArray[indexPath.row]
        }
    }
    
    
    // MARK: - Add New Stores
    
    @IBAction func addStoreButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Store", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Store", style: .default) { (action) in
            
            let newStore = Store(context: self.context)
            newStore.storeName = textField.text!
            newStore.shoppingDate = self.selectedDate
            
            self.storeArray.append(newStore)
            self.saveStores()
            
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
    
    func saveStores() {

        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    func loadStores(with request: NSFetchRequest<Store> = Store.fetchRequest()) {
        
        let predicate = NSPredicate(format: "Store.shoppingDate MATCHES %@", selectedDate! as CVarArg)
        request.predicate = predicate
        
        do {
            storeArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    

}
