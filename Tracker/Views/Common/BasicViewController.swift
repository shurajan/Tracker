//
//  BasicViewController.swift
//  Tracker
//
//  Created by Alexander Bralnin on 04.10.2024.
//

import UIKit


class BasicViewController: UIViewController {
    var screenName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesturer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let screenName {
            Log.info(message: "reporting \(screenName) screen opening")
            AnalyticsService.shared.trackEvent(event: .close, params: ["screen": "\(screenName)"])
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let screenName {
            Log.info(message: "reporting \(screenName) screen closing")
            AnalyticsService.shared.trackEvent(event: .close, params: ["screen": "\(screenName)"])
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                switch traitCollection.userInterfaceStyle {
                case .light:
                    print("Light theme selected")
                case .dark:
                    print("Dark theme selected")
                case .unspecified:
                    Log.info(message: "Theme unspecified")
                @unknown default:
                    Log.info(message: "Theme unspecified")
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    private func addTapGesturer(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction
    private func hideKeyboard() {
        view.endEditing(true)
    }
}
