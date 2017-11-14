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
  init(window: UIWindow)
  func navigate(to stage: Stage, type: Stage.NavigationType) -> Observable<Void>
  func revert(animated: Bool) -> Observable<Void>
}

