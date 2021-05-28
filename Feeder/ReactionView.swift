//
//  ReactionView.swift
//  Feeder
//
//  Created by June Kim on 5/28/21.
//

import Foundation
import UIKit

class ReactionView: UIView {
  let emojiLabel = UILabel()
  let countLabel = UILabel()
  var count: Int = 0 {
    didSet {
      countLabel.text = String(count)
    }
  }
  init(_ emoji: String){
    emojiLabel.text = emoji
    countLabel.text = "0"
    super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 130))
    emojiLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    countLabel.frame = CGRect(x: 0, y: 100, width: 100, height: 30)
    addSubview(emojiLabel)
    addSubview(countLabel)
    emojiLabel.textAlignment = .center
    countLabel.textAlignment = .center
    emojiLabel.font = .systemFont(ofSize: 50)
    countLabel.font = .systemFont(ofSize: 30)
    countLabel.textColor = .white
    emojiLabel.isUserInteractionEnabled = false
    countLabel.isUserInteractionEnabled = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
