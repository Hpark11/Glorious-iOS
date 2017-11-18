//
//  Sermon.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 13..
//  Copyright © 2017년 church. All rights reserved.
//

import Foundation
import RxDataSources

struct Sermon {
  let id: String
  let title: String
  let description: String
  let imagePath: String
  let videoId: String
  
  init() {
    self.id = ""
    self.title = ""
    self.description = ""
    self.imagePath = ""
    self.videoId = ""
  }
}

extension Sermon {
  init?(data: [String: Any]) {
    guard let id = data["id"] as? String,
      let snippet = data["snippet"] as? [String: Any],
      let title = snippet["title"] as? String,
      let description = snippet["description"] as? String,
      let thumbnails = snippet["thumbnails"] as? [String: Any] else {
        return nil
    }
    
    if let standard = thumbnails["standard"] as? [String: Any] {
      guard let imagePath = standard["url"] as? String else {return nil}
      self.imagePath = imagePath
    } else if let high = thumbnails["high"] as? [String: Any] {
      guard let imagePath = high["url"] as? String else {return nil}
      self.imagePath = imagePath
    } else { return nil }
    
    if let resourceId = snippet["resourceId"] as? [String: Any], let videoId = resourceId["videoId"] as? String {
      self.videoId = videoId
    } else {
      self.videoId = id
    }
    
    self.id = id
    self.title = title
    self.description = description
  }
}

extension Sermon: IdentifiableType, Equatable {
  var identity: String {
    return id
  }
  
  static func ==(lhs: Sermon, rhs: Sermon) -> Bool {
    return lhs.id == rhs.id
  }
}
