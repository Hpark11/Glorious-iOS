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
  
  init?(data: [String: Any]) {
    guard let id = data["id"] as? String,
      let snippet = data["snippet"] as? [String: Any],
      let title = snippet["title"] as? String,
      let description = snippet["description"] as? String,
      let thumbnails = snippet["thumbnails"] as? [String: Any],
      let standard = thumbnails["standard"] as? [String: Any],
      let imagePath = standard["url"] as? String,
      let resourceId = snippet["resourceId"] as? [String: Any],
      let videoId = resourceId["videoId"] as? String else {
      return nil
    }
    
    self.id = id
    self.title = title
    self.description = description
    self.imagePath = imagePath
    self.videoId = videoId
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
