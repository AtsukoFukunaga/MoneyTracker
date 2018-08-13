//
//  ViewController.swift
//  Calendar
//
//  Created by Atsuko Fukunaga on 8/11/18.
//  Copyright © 2018 Atsuko Fukunaga. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    //    let dayOfMonth = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    var currentMonth: String = ""
    
    var numberOfEmptyBox = 0   //The number of "empty boxes" at the start of the current month
    var nextNumberOfEmptyBox = 0   //The same as above but with the next month
    var previousNumberOfEmptyBox = 0   //The same as above but with the previous month
    var direction = 0
    var positionIndex = 0
    
    var dayCounter = 0
    
//    var highlightDate = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentMonth = months[month - 1]
        monthLabel.text = "\(currentMonth) \(year)"
        
        getStartDateDayPosition()
        
    }
    
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
//        highlightDate = -1
        
        switch currentMonth {
            
        case "December":
            month = 1
            year += 1
            direction = 1
            
            if year % 4 == 0 {
                daysInMonth[1] = 29
            } else {
                daysInMonth[1] = 28
            }
            
            getStartDateDayPosition()
            updateMonthLabel()
            
        default:
            month += 1
            direction = 1
            getStartDateDayPosition()
            updateMonthLabel()
        }
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
//        highlightDate = -1
        
        switch currentMonth {
            
        case "January":
            month = 12
            year -= 1
            direction = -1
            
            if year % 4 == 0 {
                daysInMonth[1] = 29
            } else {
                daysInMonth[1] = 28
            }
            
            getStartDateDayPosition()
            updateMonthLabel()
        default:
            month -= 1
            direction = -1
            getStartDateDayPosition()
            updateMonthLabel()
        }
        
    }
    
    
    func getStartDateDayPosition() {
        
        switch direction {
            
        case 0:
            dayCounter = day - weekday
            while dayCounter > 7 {
                dayCounter = dayCounter - 7
            }
            numberOfEmptyBox = 7 - dayCounter
            positionIndex = numberOfEmptyBox
            
        case 1...:
            if month == 1 {
                nextNumberOfEmptyBox = (positionIndex + 31) % 7
            } else {
                nextNumberOfEmptyBox = (positionIndex + daysInMonth[month - 2]) % 7
            }
            positionIndex = nextNumberOfEmptyBox
            
        case -1:
            previousNumberOfEmptyBox = 7 - ((daysInMonth[month - 1] - positionIndex) % 7)
            if previousNumberOfEmptyBox == 7 {
                previousNumberOfEmptyBox = 0
            }
            positionIndex = previousNumberOfEmptyBox
            
        default:
            fatalError()
            
        }
        
    }
    
    
    func updateMonthLabel() {
        
        currentMonth = months[month - 1]
        monthLabel.text = "\(currentMonth) \(year)"
        calendarCollectionView.reloadData()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch direction {
            
        case 0:
            return daysInMonth[month - 1] + numberOfEmptyBox
            
        case 1...:
            return daysInMonth[month - 1] + nextNumberOfEmptyBox
            
        case -1:
            return daysInMonth[month - 1] + previousNumberOfEmptyBox
            
        default:
            fatalError()
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor = UIColor.clear
        
        cell.dateLabel.layer.cornerRadius = cell.dateLabel.frame.size.width / 2
        cell.dateLabel.clipsToBounds = true
        
        if cell.dateLabel.isHidden == true {
            cell.dateLabel.isHidden = false
        }
        
        switch direction {
            
        case 0:
            cell.dateLabel.text = "\(indexPath.row + 1 - numberOfEmptyBox)"
            
        case 1...:
            cell.dateLabel.text = "\(indexPath.row + 1 - nextNumberOfEmptyBox)"
            
        case -1:
            cell.dateLabel.text = "\(indexPath.row + 1 - previousNumberOfEmptyBox)"
            
        default:
            fatalError()
            
        }
        
        if let dateCellLabel = cell.dateLabel.text {
            if Int(dateCellLabel)! <= 0 {
                cell.dateLabel.isHidden = true
            }
        }
        
        switch indexPath.row {
            
        case 0, 6, 7, 13, 14, 20, 21, 27, 28, 34, 35:
            cell.dateLabel.textColor = UIColor.red
            
        default:
            cell.dateLabel.textColor = UIColor.black
        }
        
        if currentMonth == months[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) && day == indexPath.row + 1 {
            cell.dateLabel.backgroundColor = UIColor.gray
        } else {
            cell.dateLabel.backgroundColor = UIColor.clear
        }
        
//        if indexPath.row == highlightDate {
//            cell.backgroundColor = UIColor.lightGray
//        }
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        highlightDate = indexPath.row
//        calendarCollectionView.reloadData()
        
        performSegue(withIdentifier: "goToStores", sender: self)
        
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = calendarCollectionView.frame.width / 7
        let height = width
        return CGSize(width: width, height: height)
    }
    
}

