//
//  LoopingVideoView.swift
//  Feeder
//
//  Created by June Kim on 5/28/21.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class LoopingVideoVC: AVPlayerViewController {
  let url: URL
  init(urlString: String) {
    self.url = URL(string: urlString)!
    super.init(nibName: nil, bundle: nil)
    showsPlaybackControls = false
  }
  func play() { // save memory by calling this when needed
    let player = AVPlayer(url: url)
    player.actionAtItemEnd = .none
    self.player = player
    self.player?.play()
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(playerItemDidReachEnd(notification:)),
                                           name: .AVPlayerItemDidPlayToEndTime,
                                           object: player.currentItem)
    
  }
  @objc func playerItemDidReachEnd(notification: Notification) {
    if let playerItem = notification.object as? AVPlayerItem {
      playerItem.seek(to: CMTime.zero)
    }
  }
  func pause() {
    self.player?.pause()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
