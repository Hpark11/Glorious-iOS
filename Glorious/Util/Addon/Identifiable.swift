//
//  Identifiable.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 13..
//  Copyright © 2017년 church. All rights reserved.
//

import UIKit

protocol Identifiable: class {}

extension Identifiable where Self: UIView {
  static var identifier: String {
    return String(describing: self)
  }
}

