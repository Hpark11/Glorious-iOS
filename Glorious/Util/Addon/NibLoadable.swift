//
//  NibLoadable.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 13..
//  Copyright © 2017년 church. All rights reserved.
//

import UIKit

protocol NibLoadable: class {}

extension NibLoadable where Self: UIView {
  static var nibName: String {
    return String(describing: self)
  }
}

