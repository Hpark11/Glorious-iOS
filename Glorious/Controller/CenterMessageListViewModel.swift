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

struct CenterMessageListViewModel: ViewModelBase {
  let identifier: String = R.Names.centerMessageList.v
  let navigator: NavigatorType
  
  var items: Observable<[SermonSection]> {
    return APIService.sermons(APIService.centerMessageListId).map { sermons in
      return [SermonSection(model: "본부 말씀", items: sermons)]
    }
  }
  
  init(navigator: NavigatorType) {
    self.navigator = navigator
  }
}
