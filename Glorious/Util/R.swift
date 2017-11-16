//
//  R.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 15..
//  Copyright © 2017년 church. All rights reserved.
//

import Foundation

enum R {
  enum Names: String {
    case sermonList
    case centerMessageList
    case featuredMessageList
    var v: String { return self.rawValue }
  }
  
  enum Patterns: String {
    case mainNameAndDate = "(일산영광교회\\ )([\\D]+)(\\d+\\.\\d+\\.\\d+)([\\w\\ ]*)"
    case mainTitle = "(제목\\ *:\\ *)([\\w-_?\\.]+)"
    case mainScript = "(말씀\\ *:\\ *)([\\w-_?\\.]+)"
    case centerMessage = ""
  }
}
