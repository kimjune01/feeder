//
//  UIColor + random.swift
//  Feeder
//
//  Created by June Kim on 5/28/21.
//

import Foundation
import UIKit

extension UIColor {
  static var random: UIColor {
    return UIColor(red: .random(in: 0...1),
                   green: .random(in: 0...1),
                   blue: .random(in: 0...1),
                   alpha: 1.0)
  }
}
