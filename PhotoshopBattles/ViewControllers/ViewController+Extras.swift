//
//  ViewController+Extras.swift
//  PhotoshopBattles
//
//  Created by Shane Richards on 8/10/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import UIKit

extension UIViewController {
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error!", message: "This is an alert.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Ok", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
