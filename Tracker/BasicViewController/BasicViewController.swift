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

//MARK: - Add new view to view controller
extension BasicViewController {
    internal final func addView(control newControl: UIView) {
        newControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newControl)
    }
    
    internal final func addAndActivateConstraints(from controlConstraints:[NSLayoutConstraint] = []) {
        constraints.append(contentsOf: controlConstraints)
        NSLayoutConstraint.activate(constraints)
    }
}
