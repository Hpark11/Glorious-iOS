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
  case centerMessageList(CenterMessageListViewModel)
  case featuredMessageList(FeaturedMessageListViewModel)
  
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
  private func getVC(_ root: UIViewController, id: String) -> UIViewController {
    if let nc = root as? UINavigationController {
      return nc.viewControllers.first!
    } else {
      return root
    }
  }
  
  func viewController(root: UIViewController) -> UIViewController {
    switch self {
    case .sermonList(let viewModel):
      var vc = getVC(root, id: viewModel.identifier) as! SermonListViewController
      vc.bind(to: viewModel)
      return vc.navigationController!
    case .centerMessageList(let viewModel):
      var vc = getVC(root, id: viewModel.identifier) as! CenterMessageListViewController
      vc.bind(to: viewModel)
      return vc.navigationController!
    case .featuredMessageList(let viewModel):
      var vc = getVC(root, id: viewModel.identifier) as! FeaturedMessageListViewController
      vc.bind(to: viewModel)
      return vc.navigationController!
    }
  }
}

