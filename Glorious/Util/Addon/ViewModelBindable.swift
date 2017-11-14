//
//  ViewModelBindable.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 13..
//  Copyright © 2017년 church. All rights reserved.
//

import UIKit

protocol ViewModelBindable {
  associatedtype ViewModel
  var viewModel: ViewModel! { get set }
  func bind()
}

extension ViewModelBindable where Self: UIViewController {
  mutating func bind(to model: Self.ViewModel) {
    viewModel = model
    loadViewIfNeeded()
    bind()
  }
}

