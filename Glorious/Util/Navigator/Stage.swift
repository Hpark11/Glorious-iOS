//
//  Stage.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 13..
//  Copyright © 2017년 church. All rights reserved.
//

import UIKit

enum Stage {
  case sermonList(SermonListViewModel)
  
  enum NavigationType {
    internal enum Show {
      case normal
      case detail
    }
    
    internal enum Modal {
      case normal
      case popOver
    }
    
    case root
    case show(Show)
    case modal(Modal)
  }
  
}

extension Stage {
  private func getVC(id: String) -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let nc = storyboard.instantiateViewController(withIdentifier: id) as! UINavigationController
    return nc.viewControllers.first!
  }
  
  func viewController() -> UIViewController {
    switch self {
    case .sermonList(let viewModel):
      var vc = getVC(id: viewModel.identifier) as! SermonListViewController
      vc.bind(to: viewModel)
      return vc.navigationController!
    }
  }
}
