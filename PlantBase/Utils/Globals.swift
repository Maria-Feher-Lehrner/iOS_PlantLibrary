//
//  Globals.swift
//  PlantBase
//
//  Created by user on 22.01.25.
//

import Foundation
import UIKit
import UserNotifications

func localizedLightIntensity(_ intensity: Int) -> String {
    switch intensity {
    case 1:
        return NSLocalizedString("low", comment: "Low light intensity")
    case 2:
        return NSLocalizedString("m-low", comment: "Medium-low light intensity")
    case 3:
        return NSLocalizedString("m-high", comment: "Medium-high light intensity")
    case 4:
        return NSLocalizedString("high", comment: "High light intensity")
    default:
        return NSLocalizedString("low", comment: "Fallback to low light intensity")
    }
}

func configureGlobalAppearance() {
    let appearance = UISegmentedControl.appearance()
    appearance.backgroundColor = UIColor(named: "Sage")
    appearance.selectedSegmentTintColor = UIColor(named: "Avocado")
    
    let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    appearance.setTitleTextAttributes(titleTextAttributes, for: .selected)
    
    let unselectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    appearance.setTitleTextAttributes(unselectedTextAttributes, for: .normal)
}

func requestNotificationPermissions() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        if let error = error {
            print("Error requesting notifications: \(error)")
        }
        print("Notifications permission granted: \(granted)")
    }
}
