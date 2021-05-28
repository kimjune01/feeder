//
//  MetaView.swift
//  Feeder
//
//  Created by June Kim on 5/28/21.
//

import Foundation
import UIKit

class MetaView: UIView {
  let thumbnail: UIImageView
  let titleLabel: UILabel
  
  let kThumbnailSize: CGFloat = 50
  let margin: CGFloat = 8
  
  init(frame: CGRect, user: User, title: String) {
    self.thumbnail = UIImageView(frame: CGRect(x: margin, y: margin, width: kThumbnailSize, height: kThumbnailSize))
    self.titleLabel = UILabel(frame: CGRect(x: self.thumbnail.frame.maxX + margin, y: margin + 10, width: frame.width - self.thumbnail.frame.maxX - margin * 2, height: 30))
    super.init(frame: frame)
    self.addSubview(self.thumbnail)
    self.addSubview(self.titleLabel)
    self.thumbnail.load(url: URL(string: user.imageUrl)!)
    self.titleLabel.text = title
    self.titleLabel.textColor = .white
    self.titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
    self.titleLabel.numberOfLines = 0
    let oldCenter = self.titleLabel.center
    self.titleLabel.sizeToFit()
    self.titleLabel.center = oldCenter
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
