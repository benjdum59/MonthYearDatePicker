//
//  MonthYearDatePicker.swift
//  whasq
//
//  Created by benjdum59 on 15/11/2017.
//  Copyright © 2017 benjdum59. All rights reserved.
//

import UIKit

protocol MonthYearDatePickerDelegate : class{
    func didSelect(date: Date, isValid: Bool)
    
}

public class MonthYearDatePicker: UIPickerView {
    fileprivate var maxDate : Date!
    fileprivate var minDate : Date!
    fileprivate let monthsStr = (DateFormatter().monthSymbols)!
    fileprivate let months = [Int](1...12)
    fileprivate var yearsStr : [String]!
    fileprivate var years : [Int]!
    fileprivate let calendar = NSCalendar.current
    fileprivate var selectedMonth: Int!
    fileprivate var selectedYear: Int!
    fileprivate var selected = Date().firstDayOfMonth()
    
    weak var delegatePicker : MonthYearDatePickerDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup(dates: nil)
    }
    
    public convenience init(dates:(Date, Date)?, selectedDate:Date = Date()) {
        self.init()
        setup(dates: dates)
    }

    private func setup(dates: (Date, Date)?, selectedDate:Date = Date()){
        self.delegate = self
        let currentDate = Date()
        if dates == nil {
            maxDate = currentDate
            minDate = calendar.date(byAdding: .year, value: -1, to: Date())
        } else {
            maxDate = dates!.0 > dates!.1 ? dates!.0 : dates!.1
            minDate = dates!.0 == maxDate ? dates!.1 : dates!.0
            
            if maxDate > currentDate {
                maxDate = currentDate
            }
            if minDate > currentDate {
                minDate = currentDate
            }
        }
        let minYear = calendar.component(Calendar.Component.year, from: minDate)
        let maxYear = calendar.component(Calendar.Component.year, from: maxDate)
        years = [Int](minYear...maxYear)
        yearsStr = years.map({ "\($0)" })
        
        minDate = minDate.firstDayOfMonth()
        maxDate = maxDate.firstDayOfMonth()
        var selection = selectedDate.firstDayOfMonth()
        
        if selection < minDate || selection > maxDate {
            selection = maxDate
        }
        
        selectedYear = calendar.component(Calendar.Component.year, from: selection)
        selectedMonth = calendar.component(Calendar.Component.month, from: selection)
        
        self.selectRow(months.index(of: selectedMonth) ?? months.count - 1, inComponent: 0, animated: false)
        self.selectRow(years.index(of: selectedYear) ?? years.count - 1, inComponent: 1, animated: false)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension MonthYearDatePicker : UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var color = UIColor.black
        if selected < minDate || selected > maxDate {
            if component == 0 {
                color = selectedMonth == months[row] ? UIColor.red : UIColor.black
            } else if component == 1 {
                color = selectedYear == years[row] ? UIColor.red : UIColor.black
            }
        }
        if component == 0 {
            return NSAttributedString(string: monthsStr[row], attributes: [NSAttributedStringKey.foregroundColor: color])
        }else if component == 1 {
            return NSAttributedString(string: yearsStr[row], attributes: [NSAttributedStringKey.foregroundColor: color])
        }
        return nil
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedMonth = months[row]
        } else if component == 1 {
            selectedYear = years[row]
        }
        var components = DateComponents()
        components.year = selectedYear
        components.month = selectedMonth
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        selected = calendar.date(from: components)!
        let isValid = selected >= minDate && selected <= maxDate
        delegatePicker?.didSelect(date: selected, isValid: isValid)
        pickerView.reloadAllComponents()
        
    }
}

extension MonthYearDatePicker : UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return monthsStr.count
        }
        if component == 1 {
            return yearsStr.count
        }
        return 0
    }
}

fileprivate extension Date {
    func reformatDate()->Date{
        let date = NSCalendar.current.date(bySetting: .day, value: 1, of: self)!
        return date
    }
    
    func firstDayOfMonth() -> Date {
        let calendar: Calendar = Calendar.current
        var components: DateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        components.setValue(1, for: .day)
        return calendar.date(from: components)!
    }
}

