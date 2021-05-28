//
//  PageViewController.swift
//  Animase
//
//  Created by June Kim on 2015-02-28.
//  Copyright (c) 2015 June. All rights reserved.
//
import UIKit

@objc protocol Appearable {
  /// called when the view finish decelerating onto the screen.
  func didAppearOnScreen()
  /// called when the view finish decelerating off the screen.
  func didDisappearFromScreen()
  /// called when the view begin decelerating onto the screen.
  func willAppearOnScreen()
  /// called when the view begin decelerating off the screen.
  func willDisappearFromScreen()
}

/** A pre-configured wrapper class for UIPageViewController with a simple implementation that:
 
 - encapsulates common delegate methods
 - keeps track of indexes
 - turns page control on/off with the pageControlEnabled boolean
 - comes with an Appearable hook for child view controllers
 
 */
@objc class JKPageViewController: UIPageViewController {
  /// for inspecting view hierarchy and current index.
  var debugging:Bool = false {
    didSet {
      print("JKPageViewController debugging: \(debugging)")
    }
  }
  /// allows for removal of dead space at the bottom when configured before viewDidLoad
  var pageControlEnabled:Bool = false
  /// the child view controllers.
  var pages:[UIViewController] = [UIViewController](){
    didSet{
      setInitialPage()
    }
  }
  var currentVC:UIViewController!
  var nextVC:UIViewController!
  var previousIndex:Int! = 0
  var currentIndex:Int! = 0
  var nextIndex:Int! = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.clipsToBounds = false
    delegate = self
    dataSource = self
  }
  
  override func viewDidLayoutSubviews() {
    recursivelyIterateSubviews(view: view)
    
  }
  
  /// should call to conform to Apple's guidelines for adding child view controllers
  override func didMove(toParent parent: UIViewController?) {
    super.didMove(toParent: parent)
    parent!.view.gestureRecognizers = gestureRecognizers
    
  }
  
  /// should call manually.
  func setInitialPage() {
    if pages.count > 0 {
      setViewControllers([pages[0]], direction: .forward, animated: false, completion: { (finished:Bool) -> Void in
        //
      })
    } else if debugging {
      print("JKPageViewController does not have any pages!")
    }
  }
  
  /// dead space at the bottom gets removed and makes UIPageControl's background appear transparent
  func recursivelyIterateSubviews(view: UIView) {
    if debugging {
      print("\(String(view.debugDescription)) :: frame: \(view.frame)")
    }
    for eachSubview in view.subviews {
      if let scrollView = eachSubview as? UIScrollView {
        scrollView.frame = CGRect(x:0, y:0, width:view.frame.width, height:view.frame.height)
      }
      recursivelyIterateSubviews(view: eachSubview)
    }
  }
  
}

extension JKPageViewController: UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if !completed { return }
    previousIndex = currentIndex
    currentIndex = nextIndex
    
  }
  func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    nextVC = pendingViewControllers.first
    nextIndex = pages.firstIndex(of:nextVC)!
  }
  
  
  func viewControllerAtIndex(index: Int) -> UIViewController?{
    if pages.count == 0 || index >= pages.count {
      return nil
    }
    return pages[index]
  }
  
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    if pageControlEnabled {
      return pages.count
    }
    return 0
  }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    if pageControlEnabled {
      return currentIndex
    }
    return 0
  }
  
  func scrollToVC(pageIndex:Int!, direction:UIPageViewController.NavigationDirection, animated: Bool) {
    if (pageIndex < 0 || pageIndex >= pages.count) {return}
    setViewControllers([pages[pageIndex]], direction: direction, animated: animated) { (completed:Bool) -> Void in
      (self.pages[self.currentIndex] as? Appearable)?.didDisappearFromScreen()
      (self.pages[pageIndex] as? Appearable)?.didAppearOnScreen()
      self.currentIndex = pageIndex
    }
  }
  
}

extension JKPageViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    (pages[previousIndex] as? Appearable)?.didDisappearFromScreen()
    (pages[currentIndex] as? Appearable)?.didAppearOnScreen()
    if debugging {
      print("previousIndex: \(String(describing: previousIndex)) viewController: \(pages[previousIndex])")
      print("currentIndex: \(String(describing: currentIndex)) viewController: \(pages[currentIndex])")
    }
  }
  
  func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    if debugging {
      print("nextIndex: \(String(describing: nextIndex)) viewController: \(pages[nextIndex])")
    }
    (pages[currentIndex] as? Appearable)?.willDisappearFromScreen()
    (pages[nextIndex] as? Appearable)?.willAppearOnScreen()
    
  }
  
}

extension JKPageViewController: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    if currentIndex == 0 {
      return nil
    }
    return viewControllerAtIndex(index: currentIndex-1)
  }
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    if (currentIndex == pages.count - 1) {
      return nil
    }
    return viewControllerAtIndex(index: currentIndex + 1)
  }
  
}
