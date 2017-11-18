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
    case centerMessage = "([\\d]{1,2})[,\\.\\ ]*([\\d]{1,2})[,\\.\\ ]*([\\d]{4})[,\\.\\ ]*(2nd|1st|District|Core|Biz)[,\\.\\ /]*([\\w*\\ ]*:\\ *[\\w*\\ ]*:|[\\w*\\ ]*:|:|)\\ *([\\w\\ ?,\\.’'\"!@#$%^&*\\-–]+)([\\w\\ \\-:()]*)"
    case centerMessageN = "([\\d]{4})[,\\.\\ ]*([\\d]{1,2})[,\\.\\ ]*([\\d]{1,2})[,\\.\\ ]*(biz|g|h|a|b)([\\w\\ \\-:()]*)"
    case name = "(Sp[\\w]*r)\\ *:\\ *([\\w\\.\\ ]+)"
  }
  
  enum Segues: String {
    case initSegue = "initSegue"
  }
}
