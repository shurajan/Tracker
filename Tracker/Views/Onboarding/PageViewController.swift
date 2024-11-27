//
//  PageViewController.swift
//  Tracker
//
//  Created by Alexander Bralnin on 06.11.2024.
//
import UIKit

final class PageViewController: UIPageViewController {
    
    private lazy var pages: [ContentViewController] = createPages()
    private var currentIndex: Int = 0
    
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
                            labelText: LocalizedStrings.Onboarding.firstTitle,
                            currentPage: 0,
                            numberOfPages: 2)
        firstPage.delegate = self
        
        let secondPage = ContentViewController()
        secondPage.configure(backgroundImageName: "2",
                             labelText: LocalizedStrings.Onboarding.secondTitle,
                             currentPage: 1,
                             numberOfPages: 2)
        secondPage.delegate = self
        
        return [firstPage, secondPage]
    }
}

// MARK: - ContentViewControllerDelegate
extension PageViewController: ContentViewControllerDelegate {
    func didTapPageControl(to page: Int) {
        guard page != currentIndex, page >= 0, page < pages.count else { return }
        let direction: UIPageViewController.NavigationDirection = page > currentIndex ? .forward : .reverse
        currentIndex = page
        setViewControllers([pages[page]], direction: direction, animated: true, completion: nil)
    }
}

// MARK: - UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController as! ContentViewController), currentIndex > 0 else {
            return nil
        }
        return pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController as! ContentViewController), currentIndex < pages.count - 1 else {
            return nil
        }
        return pages[currentIndex + 1]
    }
}

// MARK: - UIPageViewControllerDelegate
extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
              let currentViewController = viewControllers?.first as? ContentViewController,
              let currentIndex = pages.firstIndex(of: currentViewController) else { return }
        
        self.currentIndex = currentIndex
        currentViewController.pageControl.currentPage = currentIndex
    }
}
