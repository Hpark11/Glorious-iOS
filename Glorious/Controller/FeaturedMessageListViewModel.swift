//
//  FeaturedMessageListViewModel.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 15..
//  Copyright © 2017년 church. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources


struct FeaturedMessageListViewModel: ViewModelBase {
  let identifier: String = R.Names.featuredMessageList.v
  let navigator: NavigatorType
  
  var items: Observable<[SermonSection]> {
    return Observable.zip(APIService.sermon(APIService.messageId62),
                          APIService.sermon(APIService.messageIdMain),
                          APIService.sermon(APIService.messageId1Min),
                          APIService.sermon(APIService.messageId3Min),
                          APIService.sermon(APIService.messageId5Min)) {
      return [SermonSection(model: "", items: [$0, $1, $2, $3, $4])]
    }
  }

  init(navigator: NavigatorType) {
    self.navigator = navigator
  }
}
