//
//  AddItemsViewController.swift
//  MoneyTracker
//
//  Created by Atsuko Fukunaga on 8/18/18.
//  Copyright © 2018 Atsuko Fukunaga. All rights reserved.
//

import UIKit

class AddItemsViewController: UIViewController {

    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var subcategoryPicker: UIPickerView!
    @IBOutlet weak var amount: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ItemViewController
        
        destinationVC.loadItems()

    }

}
