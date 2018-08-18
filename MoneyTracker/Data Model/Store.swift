//
//  Store.swift
//  MoneyTracker
//
//  Created by Atsuko Fukunaga on 8/17/18.
//  Copyright © 2018 Atsuko Fukunaga. All rights reserved.
//

import Foundation
import RealmSwift

class Store: Object {
    
    @objc dynamic var shoppingDate: String = ""
    @objc dynamic var storeName: String = ""
    let items = List<Item>()
    
}
