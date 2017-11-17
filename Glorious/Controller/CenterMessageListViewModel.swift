//
//  CenterMessageViewModel.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 15..
//  Copyright © 2017년 church. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import Action

struct CenterMessageListViewModel: ViewModelBase {
  let identifier: String = R.Names.centerMessageList.v
  let navigator: NavigatorType
  var videoId: String?
  var initSermon = Variable<Sermon>(Sermon())
  
  var items: Observable<[SermonSection]> {
    return APIService.sermons(APIService.centerMessageListId).map { sermons in
      if let first = sermons.first { self.initSermon.value = first }
      return [SermonSection(model: "본부 말씀", items: sermons)]
    }
  }
  
  lazy var playAction = CocoaAction {_ in
    return Observable.empty()
  }
  
  init(navigator: NavigatorType) {
    self.navigator = navigator
  }
}
