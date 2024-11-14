//
//  PageViewController.swift
//  Tracker
//
//  Created by Alexander Bralnin on 06.11.2024.
//
import UIKit

final class PageViewController: UIPageViewController {
    
    private lazy var pages: [ContentViewController] = createPages()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: false, completion: nil)
        }
    }
    
    private func createPages() -> [ContentViewController] {
        let firstPage = ContentViewController()
        firstPage.configure(backgroundImageName: "1",
                            labelText: LocalizedStrings.Onboarding.firstTitle)
        
        let secondPage = ContentViewController()
        secondPage.configure(backgroundImageName: "2",
                             labelText: LocalizedStrings.Onboarding.secondTitle)
        
        return [firstPage, secondPage]
    }
}

// MARK: - UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentPage = viewController as? ContentViewController,
              let currentIndex = pages.firstIndex(of: currentPage) else {
            return nil
        }
    
        let previousIndex = currentIndex - 1
        return previousIndex >= 0 ? pages[previousIndex] : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentPage = viewController as? ContentViewController,
              let currentIndex = pages.firstIndex(of: currentPage) else {
            return nil
        }
        
        let nextIndex = currentIndex + 1
        return nextIndex < pages.count ? pages[nextIndex] : nil
    }
    
}

// MARK: - UIPageViewControllerDelegate
extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
           let currentViewController = viewControllers?.first as? ContentViewController,
           let currentIndex = pages.firstIndex(of: currentViewController)
        else { return }
        pages[currentIndex].pageControl.currentPage = currentIndex
    }
}
