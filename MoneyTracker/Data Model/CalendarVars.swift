//
//  CalendarVars.swift
//  Calendar
//
//  Created by Atsuko Fukunaga on 8/11/18.
//  Copyright © 2018 Atsuko Fukunaga. All rights reserved.
//

import Foundation

let date = Date()
let calendar = Calendar.current

let day = calendar.component(.day, from: date)
let weekday = calendar.component(.weekday, from: date)
var month = calendar.component(.month, from: date)
var year = calendar.component(.year, from: date)
