//
//  DatePickerActionSheet.swift
//  scrollTest
//
//  Created by Brian Carothers on 1/11/18.
//  Copyright © 2018 Brian Carothers. All rights reserved.
//

import UIKit

class DatePickerView: UIPickerView  {
    
    enum Component: Int {
        case Month = 0
        case Day = 1
        case Year = 2
    }
    
    let LABEL_TAG = 43
    let bigRowCount = 1000
    let numberOfComponentsRequired = 3
    
    let months = ["----", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var days: [String] {
        get {
            var days: [String] = [String]()
            days.append("----")
            for i in 1...31 {
                days.append(String(format: "%02d", i))
            }
            return days
        }
    }
    var years: [String] {
        get {
            var years: [String] = [String]()
            
            for i in minYear...maxYear {
                years.append("\(i)")
            }
            
            let currentYearIndex = years.index(of: currentYear)!
            years.insert("----", at: currentYearIndex)
            
            return years;
        }
    }
    
    var bigRowMonthsCount: Int {
        get {
            return bigRowCount * months.count
        }
    }
    
    var bigRowDaysCount: Int {
        get {
            return bigRowCount * days.count
        }
    }
    
    var bigRowYearsCount: Int {
        get {
            return bigRowCount * years.count
        }
    }
    
    
    let rowHeight: NSInteger = 44
    
    /**
     Will be returned in user's current TimeZone settings
     **/
    var date: NSDate {
        get {
            let month = self.months[selectedRow(inComponent: Component.Month.rawValue) % months.count]
            let date = self.days[selectedRow(inComponent: Component.Day.rawValue) % days.count]
            let year = self.years[selectedRow(inComponent: Component.Year.rawValue) % years.count]
            let formatter = DateFormatter()
            formatter.dateFormat = "MM DD yyyy"
            return formatter.date(from: "\(month) \(date) \(year)")! as NSDate
        }
    }
    
    var minYear: Int!
    var maxYear: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadDefaultParameters()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadDefaultParameters()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        loadDefaultParameters()
    }
    
    func loadDefaultParameters() {
        minYear = 1950
        maxYear = 2100
        
        self.delegate = self
        self.dataSource = self
        
    }
    
    
    func setup(minYear: NSInteger, andMaxYear maxYear: NSInteger) {
        self.minYear = minYear
        
        if maxYear > minYear {
            self.maxYear = maxYear
        } else {
            self.maxYear = minYear + 10
        }
    }
    
    ///////
    func selectToday() {
        selectRow(todayIndexPath.index(atPosition: 0), inComponent: Component.Month.rawValue, animated: false)
        selectRow(0, inComponent: Component.Day.rawValue, animated: false)
        //selectRow(todayIndexPath.index(atPosition: 1), inComponent: Component.Day.rawValue, animated: false)
        selectRow(todayIndexPath.index(atPosition: 2), inComponent: Component.Year.rawValue, animated: false)
    }
    
    //////
    var todayIndexPath: NSIndexPath {
        get {
            var indexSection1 = 0
            var indexSection2 = 0
            var indexSection3 = 0
            
            //            for cellMonth in months {
            //                if cellMonth == currentMonthName {
            //                    indexSection1 = Int(months.index(of: cellMonth)!)
            //                    break
            //                }
            //            }
            //
            //            for cellDay in days {
            //                if cellDay == currentDay {
            //                    indexSection2 = Int(days.index(of: cellDay)!)
            //                    break
            //                }
            //            }
            indexSection1 = months.index(of: currentMonthName)!
            indexSection2 = days.index(of: "----")!
            indexSection3 = years.index(of: "----")!
            
            //for cellYear in years {
            //                if cellYear == currentYear {
            //                    indexSection3 = Int(years.index(of: cellYear)!)
            //                    break
            //                }
            //}
            return NSIndexPath(indexes: [indexSection1, indexSection2, indexSection3], length: 3)
        }
    }
    
    var currentMonthName: String {
        get {
            let formatter = DateFormatter()
            let locale = NSLocale(localeIdentifier: "en_US")
            formatter.locale = locale as Locale!
            formatter.dateFormat = "MMMM"
            return formatter.string(from: NSDate() as Date)
        }
    }
    
    var currentDay: String {
        get {
            let formatter = DateFormatter()
            let locale = NSLocale(localeIdentifier: "en_US")
            formatter.locale = locale as Locale!
            formatter.dateFormat = "DD"
            return formatter.string(from: NSDate() as Date)
        }
    }
    
    var currentYear: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            return formatter.string(from: NSDate() as Date)
        }
    }
    
    
    func selectedColorForComponent(component: NSInteger) -> UIColor {
        return .black
    }
    
    func colorForComponent(component: NSInteger) -> UIColor {
        return .black
    }
    
    
    func selectedFontForComponent(component: NSInteger) -> UIFont {
        return UIFont.boldSystemFont(ofSize: 17)
    }
    
    func fontForComponent(component: NSInteger) -> UIFont {
        return UIFont.boldSystemFont(ofSize: 17)
    }
    
    
    
    func titleForRow(row: Int, forComponent component: Int) -> String? {
        if component == Component.Month.rawValue {
            return self.months[row % self.months.count]
        } else if component == Component.Day.rawValue {
            return self.days[row % self.days.count]
        } else {
            return self.years[row % self.years.count]
        }
    }
    
    
    func labelForComponent(component: NSInteger) -> UILabel {
        let frame = CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: CGFloat(rowHeight))
        let label = UILabel(frame: frame)
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.clear
        label.isUserInteractionEnabled = false
        label.tag = LABEL_TAG
        return label
    }
}

extension DatePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfComponentsRequired
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == Component.Month.rawValue) {
            return bigRowMonthsCount
        } else if (component == Component.Day.rawValue) {
            return bigRowDaysCount
        } else {
            return bigRowYearsCount
        }
    }
    
    
    ///
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.bounds.size.width / CGFloat(numberOfComponentsRequired)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var selected = false
        
        if component == Component.Month.rawValue {
            let monthName = self.months[(row % self.months.count)]
            if monthName == currentMonthName {
                selected = true
            }
        } else if component == Component.Day.rawValue {
            let day = self.days[(row % self.days.count)]
            if day == currentDay {
                selected = true
            }
        } else {
            let year = self.years[(row % self.years.count)]
            if year == currentYear {
                selected = true
            }
        }
        
        var returnView: UILabel
        if view?.tag == LABEL_TAG {
            returnView = view as! UILabel
        } else {
            returnView = labelForComponent(component: component)
        }
        
        returnView.font = selected ? selectedFontForComponent(component: component) : fontForComponent(component: component)
        returnView.textColor = selected ? selectedColorForComponent(component: component) : colorForComponent(component: component)
        
        returnView.text = titleForRow(row: row, forComponent: component)
        
        return returnView
    }
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(rowHeight)
    }
    
}

