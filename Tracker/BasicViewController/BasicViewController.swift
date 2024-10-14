//
//  BasicViewController.swift
//  Tracker
//
//  Created by Alexander Bralnin on 04.10.2024.
//

import UIKit


class BasicViewController: UIViewController {
    private var constraints = [NSLayoutConstraint]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
}
