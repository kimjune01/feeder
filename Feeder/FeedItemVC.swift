//
//  FeedItemVC.swift
//  Feeder
//
//  Created by June Kim on 5/28/21.
//

import Foundation
import UIKit

class FeedItemVC: UIViewController {
  var feedItem: FeedItem
  init(_ feedItem: FeedItem) {
    self.feedItem = feedItem
    super.init(nibName: nil, bundle: nil)
  }
  let contentView = UIView()
  var metaView: MetaView!
  var videoVC: LoopingVideoVC!
  
  let reactionScrollView = UIScrollView()
  let heartView = ReactionView("❤️")
  let fireView = ReactionView("🔥")
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    metaView = MetaView(frame: CGRect(x: 0, y: UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 44, width: view.bounds.width, height: 80), user: feedItem.user, title: feedItem.title)
    videoVC = LoopingVideoVC(urlString: self.feedItem.videoUrl)
    
    
    // feed item VC view > reaction scroll view > content view > video view
    reactionScrollView.frame = view.bounds
    reactionScrollView.addSubview(contentView)
    view.addSubview(reactionScrollView)
    // HAX
    reactionScrollView.contentSize = CGSize(width: view.bounds.size.width + 1, height: view.bounds.size.height)
    
    contentView.frame = view.bounds
    addChild(videoVC)
    contentView.addSubview(videoVC.view)
    videoVC.didMove(toParent: self)
    contentView.addSubview(metaView)

    // feed item VC view > reactionUnderView
    view.addSubview(heartView)
    view.addSubview(fireView)
    heartView.center = CGPoint(x: view.bounds.width * 0.1, y: view.bounds.height * 0.5)
    fireView.center = CGPoint(x: view.bounds.width * 0.9, y: view.bounds.height * 0.5)
    
    let heartTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(incrementHeart))
    heartView.addGestureRecognizer(heartTapRecognizer)
    let fireTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(incrementFire))
    fireView.addGestureRecognizer(fireTapRecognizer)

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    reactionScrollView.delegate = self
    videoVC.play()
  }
  
  @objc
  func incrementHeart() {
    heartView.count += 1
  }
  
  @objc
  func incrementFire() {
    fireView.count += 1
  }
}

extension FeedItemVC: UIScrollViewDelegate {
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if abs(scrollView.contentOffset.x) > 10 {
      if scrollView.contentOffset.x < 0 {
        incrementHeart()
      }
      if scrollView.contentOffset.x > 0 {
        incrementFire()
      }
    }
  }
}
