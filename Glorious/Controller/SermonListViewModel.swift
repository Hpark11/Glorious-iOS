//
//  SermonListViewModel.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 13..
//  Copyright © 2017년 church. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import Action

typealias SermonSection = AnimatableSectionModel<String, Sermon>

struct SermonListViewModel: ViewModelBase {
  let identifier: String = "SermonList"
  let navigator: NavigatorType
  
  var items: Observable<[SermonSection]> {
    return APIService.sermons().map { sermons in
      return [SermonSection(model: "강단 말씀", items: sermons)]
    }
  }
  
  init(navigator: NavigatorType) {
    self.navigator = navigator
  }
}
