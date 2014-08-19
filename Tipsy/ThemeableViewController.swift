//
//  ThemeableViewController.swift
//  Tipsy
//
//  Created by Jerry Su on 8/18/14.
//  Copyright (c) 2014 jsu. All rights reserved.
//

import UIKit

class ThemeableViewController: UIViewController {

    var currentTheme: Theme = Theme.DEFAULT

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.applyTheme(currentTheme)
    }

    final func applyTheme(theme: Theme) {
        switch theme {
            case Theme.DARK:
                self.view.backgroundColor = UIColor.blackColor()
                UIView.appearance().tintColor = UIColor.whiteColor()
                UILabel.appearance().tintColor = UIColor.whiteColor()
                UILabel.appearance().textColor = UIColor.whiteColor()
                UITextField.appearance().backgroundColor = UIColor.darkGrayColor()
                UITextField.appearance().textColor = UIColor.whiteColor()
                UITextField.appearance().keyboardAppearance = UIKeyboardAppearance.Dark
                self.navigationController.navigationBar.barTintColor = UIColor.darkGrayColor()
                self.navigationController.navigationBar.tintColor = UIColor.whiteColor()
                self.navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
                break
            default:
                self.view.backgroundColor = UIColor.whiteColor()
                // Note: Setting this to nil doesn't always work. Manually set to "iOS blue".
                UIView.appearance().tintColor =
                    UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
                UILabel.appearance().tintColor = nil
                UILabel.appearance().textColor = nil
                UITextField.appearance().backgroundColor = nil
                UITextField.appearance().textColor = nil
                UITextField.appearance().keyboardAppearance = UIKeyboardAppearance.Light
                self.navigationController.navigationBar.barTintColor = nil
                self.navigationController.navigationBar.tintColor = nil
                self.navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        }

        currentTheme = theme

        // Found this on StackOverflow:
        // http://stackoverflow.com/questions/20875107/
        // Force the current view to redraw after changes are made.
        if let superView = self.view.superview {
            let currentView = self.view
            currentView.removeFromSuperview()
            superView.addSubview(currentView)
        }
    }
}

enum Theme: Int {
    case DEFAULT = 0, DARK = 1
}