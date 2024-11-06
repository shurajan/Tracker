//
//  PageViewController.swift
//  Tracker
//
//  Created by Alexander Bralnin on 06.11.2024.
//

import UIKit

final class PageViewController: UIPageViewController {
    
    private lazy var pages: [ContentViewController] = {
        let firstPage = ContentViewController()
        firstPage.configure(backgroundImageName: "1",
                            labelText: "Отслеживайте только то, что хотите")
        
        
        let secondPage = ContentViewController()
        secondPage.configure(backgroundImageName: "2",
                             labelText: "Даже если это не литры воды и йога")
        
        return [firstPage, secondPage]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: false, completion: nil)
        }
    }
}
// MARK: - UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController as! ContentViewController) else {
            return nil
        }
        let previousIndex = currentIndex - 1
        return previousIndex >= 0 ? pages[previousIndex] : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController as! ContentViewController) else {
            return nil
        }
        let nextIndex = currentIndex + 1
        return nextIndex < pages.count ? pages[nextIndex] : nil
    }
    
}

// MARK: - UIPageViewControllerDelegate
extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController as! ContentViewController) {
            pages[currentIndex].pageControl.currentPage = currentIndex
        }
    }
}
