//
//  ViewController.swift
//  Tipsy
//
//  Created by Jerry Su on 8/13/14.
//  Copyright (c) 2014 jsu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
                            
    let TIP_CONTROL_DEFAULT_SELECTED_INDEX: Int = 1

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!

    let defaults = NSUserDefaults.standardUserDefaults()
    let formatter = NSNumberFormatter()

    var billFieldValue: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        formatter.numberStyle = .CurrencyStyle

        billField.delegate = self;
        billField.placeholder = formatter.stringFromNumber(0)

        var tipControlSelected = TIP_CONTROL_DEFAULT_SELECTED_INDEX

        if let lastSetDate = defaults.objectForKey("LastSetDate") as? NSDate {
            let timeInterval = lastSetDate.timeIntervalSinceNow
            if abs(timeInterval) < 600 {
                billFieldValue = defaults.integerForKey("BillFieldValue")
                tipControlSelected = defaults.integerForKey("TipControlSelected")

                if billFieldValue > 0 {
                    billField.text = formatter.stringFromNumber(Double(billFieldValue) / 100)
                }
            }
        }

        tipControl.selectedSegmentIndex = tipControlSelected

        self.calculateTipAndTotal()
    }

    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        if (string >= "0" && string <= "9") {
            // Prevent the Integer from overflowing
            // FIXME: Find a better way to fix this.
            var newValue = billFieldValue &* 10 &+ string.toInt()!
            if (newValue > billFieldValue) {
                billFieldValue = newValue
            }
        } else if (string == "") {
            billFieldValue = billFieldValue / 10;
        }

        if (billFieldValue > 0) {
            textField.text = formatter.stringFromNumber(Double(billFieldValue) / 100)
        } else {
            textField.text = ""
        }
        self.calculateTipAndTotal()

        defaults.setInteger(billFieldValue, forKey: "BillFieldValue")
        defaults.setObject(NSDate(), forKey: "LastSetDate")

        return false
    }

    @IBAction func onTipControlChanged(sender: AnyObject) {
        self.calculateTipAndTotal()
        defaults.setInteger(tipControl.selectedSegmentIndex, forKey: "TipControlSelected")
    }

    func calculateTipAndTotal() {
        var tipPercentages = [0.18, 0.2, 0.22]
        var tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]

        var billAmount = Double(billFieldValue) / 100
        var tip = billAmount * tipPercentage
        var total = billAmount + tip

        tipLabel.text = formatter.stringFromNumber(tip)
        totalLabel.text = formatter.stringFromNumber(total)
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}

