//
//  User.swift
//  Feeder
//
//  Created by June Kim on 5/28/21.
//

import Foundation

struct User {
  let id: Int
  let imageUrl: String
  let username: String
  
  static var ErrorUser: User {
    return User(id: -1, imageUrl: "", username: "OOPS")
  }
  
  static func from(json: Dictionary<String,Any>) -> User {
    if let id = json["id"] as? Int,
       let username = json["username"] as? String,
       let imageUrl = json["image_url"] as? String {
      return User(id: id, imageUrl: imageUrl, username: username)
    }
    return ErrorUser
  }
}
