//
//  ViewController.swift
//  MonthYearDatePicker
//
//  Created by benjdum59 on 11/21/2017.
//  Copyright (c) 2017 benjdum59. All rights reserved.
//

import UIKit
import MonthYearDatePicker

class ViewController: UIViewController {
    @IBOutlet weak var firstTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTextField.inputView = MonthYearDatePicker()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

