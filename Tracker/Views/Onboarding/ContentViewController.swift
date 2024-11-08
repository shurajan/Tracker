//
//  ContentViewController.swift
//  Tracker
//
//  Created by Alexander Bralnin on 06.11.2024.
//

import UIKit

class ContentViewController: UIViewController {
    
    private var backgroundImageName: String = ""
    private var labelText: String = ""
    private var pageControlCurrentPage: Int = 0
    private var pageControlNumberOfPages: Int = 2
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ysWhite, for: .normal)
        button.backgroundColor = .ysBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private(set) lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPageIndicatorTintColor = .black
        control.pageIndicatorTintColor = .lightGray
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func configure(backgroundImageName: String, labelText: String) {
        self.backgroundImageName = backgroundImageName
        self.labelText = labelText
        
        backgroundImageView.image = UIImage(named: backgroundImageName)
        label.text = labelText
        pageControl.currentPage = pageControlCurrentPage
        pageControl.numberOfPages = pageControlNumberOfPages
    }
    
    private func setupLayout() {
        view.addSubview(backgroundImageView)
        view.addSubview(label)
        view.addSubview(startButton)
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            label.widthAnchor.constraint(equalToConstant: 76),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 64),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:  -50),
            startButton.heightAnchor.constraint(equalToConstant: 60),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -24)
        ])
    }
    
    //MARK: - IB Outlet
    @IBAction
    private func startButtonTapped() {
        let tabBarController = MainTabBarController()
        tabBarController.addTabItems()
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
            UserDefaults.standard.isOnboarded = true
        } else {
            Log.warn(message: "Failed to load Trackers")
        }
    }
}
