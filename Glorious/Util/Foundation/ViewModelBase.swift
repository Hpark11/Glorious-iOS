//
//  ViewModelBase.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 13..
//  Copyright © 2017년 church. All rights reserved.
//

import Foundation

protocol ViewModelBase {
  var identifier: String { get }
  var navigator: NavigatorType { get }
}

