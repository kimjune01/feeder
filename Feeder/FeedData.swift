//
//  FeedData.swift
//  Feeder
//
//  Created by June Kim on 5/28/21.
//

import Foundation

class FeedData {
  static let apiBaseUrl = "https://mock-feed-server.herokuapp.com/videos"
  
  
  static func getVideos(_ completion: @escaping ([FeedItem])->()) {
    let suffix = "?page_number=0&page_size=10"
    let url = URL(string: apiBaseUrl + suffix)!
    
    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
      guard let data = data else { return }
      if let jsonArray = try! JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>] {
        let feedItems = jsonArray.map { j in
          return FeedItem.from(json: j)
        }
        completion(feedItems)
      }
    }
    task.resume()
  }
}
