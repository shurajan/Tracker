//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Alexander Bralnin on 04.10.2024.
//
import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func addTabItems(){
        let trackerViewController = UINavigationController(rootViewController: TrackerViewController())
        trackerViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Record"), tag: 0)
        
        //let statisticsViewController = UINavigationController(rootViewController: StatisticsViewController())
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Hare"), tag: 1)
        self.viewControllers = [trackerViewController, statisticsViewController]
    }
}
