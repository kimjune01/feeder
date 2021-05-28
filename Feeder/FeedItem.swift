//
//  Video.swift
//  Feeder
//
//  Created by June Kim on 5/28/21.
//

import Foundation

struct FeedItem {
  let id: Int
  let title: String
  let user: User
  let videoUrl: String
  
  static var ErrorFeedItem: FeedItem {
    return FeedItem(id:-1, title: "OOPS", user: User.ErrorUser, videoUrl: "")
  }
  
  static func from(json: Dictionary<String,Any>) -> FeedItem {
    if let id = json["id"] as? Int,
       let title = json["title"] as? String,
       let user = json["user"] as? Dictionary<String,Any>,
       let videoUrl = json["video_url"] as? String {
      return FeedItem(id: id, title: title, user: User.from(json: user), videoUrl: videoUrl)
    }
    return ErrorFeedItem
  }
}
