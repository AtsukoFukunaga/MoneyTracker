//
//  Item.swift
//  MoneyTracker
//
//  Created by Atsuko Fukunaga on 8/17/18.
//  Copyright © 2018 Atsuko Fukunaga. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var item: String = ""
    @objc dynamic var expense: Int = 0
    @objc dynamic var income: Int = 0
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Store.self, property: "items")
    
}
