//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Alexander Bralnin on 11.10.2024.
//

import UIKit

class TrackerCreationViewController: BasicViewController {
    private var constraints = [NSLayoutConstraint]()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        constraints.append(contentsOf: [
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        return label
    }()
    
    private lazy var habitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Привычка", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        constraints.append(contentsOf: [
            button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return button
    }()
    
    private lazy var irregularEventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Нерегулярные событие", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        constraints.append(contentsOf: [
            button.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 20),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawSelf()
    }
    
    private func drawSelf(){
        view.backgroundColor = .white
        
        addView(control: titleLabel)
        addView(control: habitButton)
        addView(control: irregularEventButton)
        
        addAndActivateConstraints(from: constraints)
    }
}
