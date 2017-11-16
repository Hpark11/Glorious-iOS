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

class SermonListViewModel: ViewModelBase {
  let identifier: String = R.Names.sermonList.v
  let navigator: NavigatorType
  var videoId: String?
  var initSermon: Variable<Sermon>?
  
  var items: Observable<[SermonSection]> {
    return APIService.sermons(APIService.sermonListId).map { [unowned self] sermons in
      if let first = sermons.first { self.initSermon?.value = first }
      return [SermonSection(model: "강단 말씀", items: sermons)]
    }
  }

  lazy var playAction = CocoaAction {_ in
    return Observable.empty()
  }

  init(navigator: NavigatorType) {
    self.navigator = navigator
    //self.initSermon = Variable(
  }
}
