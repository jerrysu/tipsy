//
//  SettingsViewController.swift
//  Tipsy
//
//  Created by Jerry Su on 8/14/14.
//  Copyright (c) 2014 jsu. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var delegate: SettingsViewControllerDelegate?

    @IBOutlet weak var tipExcellentField: UITextField!
    @IBOutlet weak var tipSatisfactoryField: UITextField!
    @IBOutlet weak var tipTerribleField: UITextField!

    @IBOutlet weak var tipExcellentStepper: UIStepper!
    @IBOutlet weak var tipSatisfactoryStepper: UIStepper!
    @IBOutlet weak var tipTerribleStepper: UIStepper!

    var fieldMap: Array<UITextField> = []
    var stepperMap: Array<UIStepper> = []

    var tipPercentages: Array<Double> = []

    @IBOutlet weak var themeControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: This seems kind of sketchy. Maybe switch to a modal segue?
        self.navigationItem.setHidesBackButton(true, animated: true)

        fieldMap = [
            tipTerribleField,
            tipSatisfactoryField,
            tipExcellentField
        ]

        stepperMap = [
            tipTerribleStepper,
            tipSatisfactoryStepper,
            tipExcellentStepper
        ]

        for (index, percentage) in enumerate(tipPercentages) {
            stepperMap[index].value = percentage
            fieldMap[index].text = String(format: "%d%%", Int(round(percentage * 100)))
        }
    }

    @IBAction func onValueChanged(sender: UIStepper) {
        if let index = find(stepperMap, sender) {
            tipPercentages[index] = sender.value
            fieldMap[index].text = String(format: "%d%%", Int(round(sender.value * 100)))
        }
    }

    @IBAction func onSave(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(tipPercentages, forKey: "TipPercentages")

        if delegate {
            delegate!.onSettingsDone(self)
        }
    }
}

protocol SettingsViewControllerDelegate{
    func onSettingsDone(controller: SettingsViewController)
}
