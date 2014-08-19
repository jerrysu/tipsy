//
//  ViewController.swift
//  Tipsy
//
//  Created by Jerry Su on 8/13/14.
//  Copyright (c) 2014 jsu. All rights reserved.
//

import UIKit

class ViewController: ThemeableViewController, UITextFieldDelegate, SettingsViewControllerDelegate {

    let TIP_CONTROL_DEFAULT_SELECTED_INDEX: Int = 1
    let TIP_CONTROL_DEFAULT_PERCENTAGES: Array<Double> = [0.1, 0.15, 0.2]

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!

    let defaults = NSUserDefaults.standardUserDefaults()
    let formatter = NSNumberFormatter()

    var billFieldValue: Int = 0

    var tipPercentages: Array<Double>

    override init(coder aDecoder: NSCoder) {
        formatter.numberStyle = .CurrencyStyle

        if let storedPercentages = defaults.arrayForKey("TipPercentages") {
            tipPercentages = storedPercentages as Array<Double>
        } else {
            tipPercentages = TIP_CONTROL_DEFAULT_PERCENTAGES
        }

        super.init(coder: aDecoder)

        if let storedTheme = Theme.fromRaw(defaults.integerForKey("Theme")) {
            currentTheme = storedTheme
        }
    }

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

        self.setTipControlTitles()
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

    func setTipControlTitles() {
        for (index, percentage) in enumerate(tipPercentages) {
            let title = String(format: "%d%%", Int(round(percentage * 100)))
            tipControl.setTitle(title, forSegmentAtIndex: index)
        }
    }

    @IBAction func onTipControlChanged(sender: AnyObject) {
        self.calculateTipAndTotal()
        defaults.setInteger(tipControl.selectedSegmentIndex, forKey: "TipControlSelected")
    }

    func calculateTipAndTotal() {
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

    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "settings" {
            let settingsViewController = segue.destinationViewController as SettingsViewController
            settingsViewController.delegate = self
            settingsViewController.tipPercentages = tipPercentages
            settingsViewController.currentTheme = currentTheme
        }
    }

    func onSettingsDone(controller: SettingsViewController) {
        tipPercentages = controller.tipPercentages
        currentTheme = controller.currentTheme
        self.setTipControlTitles()

        controller.navigationController.popViewControllerAnimated(true)
    }
}