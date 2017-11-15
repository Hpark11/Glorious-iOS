//
//  NavigatorType.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 13..
//  Copyright © 2017년 church. All rights reserved.
//

import UIKit
import RxSwift

protocol NavigatorType {
  init(root: UIViewController)
  
  @discardableResult
  func navigate(to stage: Stage, type: Stage.NavigationType) -> Observable<Void>
  
  @discardableResult
  func revert(animated: Bool) -> Observable<Void>
}

