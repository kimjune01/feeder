

import UIKit

class RootViewController: UIViewController {
  let pageVC = JKPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
  var feedItems: [FeedItem] = [] {
    didSet {
      pageVC.pages = feedItems.map{feedItem in FeedItemVC(feedItem)}
      pageVC.scrollToVC(pageIndex: pageVC.pages.count - 1, direction: .reverse, animated: false)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    FeedData.getVideos { feedItems in
      DispatchQueue.main.async {
        self.feedItems = feedItems
      }
    }
    addChild(pageVC)
    view.addSubview(pageVC.view)
    pageVC.didMove(toParent: self)
  }
  
  override func viewWillAppear(_ animated: Bool) {
  }
  
  override func viewDidAppear(_ animated: Bool) {
  }


}

