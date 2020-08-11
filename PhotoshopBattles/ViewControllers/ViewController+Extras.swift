//
//  ViewController+Extras.swift
//  PhotoshopBattles
//
//  Created by Shane Richards on 8/10/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert() {
        let alert = UIAlertController(title: "My Alert", message: "This is an alert.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"Cancel\" alert occured.")
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Third", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"Third\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
