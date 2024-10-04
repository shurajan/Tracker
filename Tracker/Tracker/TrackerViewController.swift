//
//  MainTabBarViewController.swift
//  Tracker
//
//  Created by Alexander Bralnin on 04.10.2024.
//
import UIKit

final class TrackerViewController: LightStatusBarViewController {
    private var descriptionLabel: UILabel = {
        let view = UILabel()
        view.text = "not available"
        view.font = UIFont.systemFont(ofSize: 13)
        //view.textColor = UIColor.ypWhiteIOS
        view.numberOfLines = 0
        return view
    } ()
    

    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        drawSelf()
    }
    
    //MARK: - View Layout methods
    private func drawSelf(){
        view.backgroundColor = UIColor.white
        
        addView(control: descriptionLabel)
        let constraints = [descriptionLabel.widthAnchor.constraint(equalToConstant: 70),
                           descriptionLabel.heightAnchor.constraint(equalToConstant: 70),
                           descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                           descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ]
        addAndActivateConstraints(from: constraints)
    }
    
}
