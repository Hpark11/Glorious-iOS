//
//  Utils.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 16..
//  Copyright © 2017년 church. All rights reserved.
//

import Foundation

struct Utils {
  static func replaced(_ pattern: String, text: String, template: String) -> String {
    guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else { return "" }
    return regex.stringByReplacingMatches(in: text, options: [], range: NSRange(location: 0, length: text.count), withTemplate: template)
  }
}
