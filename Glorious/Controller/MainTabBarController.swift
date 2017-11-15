//
//  MainTabBarController.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 15..
//  Copyright © 2017년 church. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initViews()
  }
  
  private func initViews() {
    guard let storyboard = storyboard else { return }
    
    let sermonListNavigationController = storyboard.instantiateViewController(withIdentifier: R.Names.sermonList.v) as! UINavigationController
    sermonListNavigationController.title = "강단 메세지"
    sermonListNavigationController.tabBarItem.image = UIImage(named: "sermon")
    sermonListNavigationController.navigationBar.setItems([UINavigationItem(title: "강단 메세지")], animated: false)
    
    let centerMessageListNavigationController = storyboard.instantiateViewController(withIdentifier: R.Names.centerMessageList.v) as! UINavigationController
    centerMessageListNavigationController.title = "본부 메세지"
    centerMessageListNavigationController.tabBarItem.image = UIImage(named: "center")
    centerMessageListNavigationController.navigationBar.setItems([UINavigationItem(title: "본부 메세지")], animated: false)
    
    let featuredMessageListNavigationController = storyboard.instantiateViewController(withIdentifier: R.Names.featuredMessageList.v) as! UINavigationController
    featuredMessageListNavigationController.title = "구원의길"
    featuredMessageListNavigationController.tabBarItem.image = UIImage(named: "special")
    featuredMessageListNavigationController.navigationBar.setItems([UINavigationItem(title: "구원의길")], animated: false)
    
    let sermonListNavigator = Navigator(root: sermonListNavigationController)
    let sermonListViewModel = SermonListViewModel(navigator: sermonListNavigator)
    sermonListNavigator.navigate(to: Stage.sermonList(sermonListViewModel), type: .root)
    
    let centerMessageListNavigator = Navigator(root: centerMessageListNavigationController)
    let centerMessageListViewModel = CenterMessageListViewModel(navigator: centerMessageListNavigator)
    centerMessageListNavigator.navigate(to: Stage.centerMessageList(centerMessageListViewModel), type: .root)
    
    let featuredMessageListNavigator = Navigator(root: featuredMessageListNavigationController)
    let featuredMessageListViewModel = FeaturedMessageListViewModel(navigator: featuredMessageListNavigator)
    featuredMessageListNavigator.navigate(to: Stage.featuredMessageList(featuredMessageListViewModel), type: .root)
    
    viewControllers = [sermonListNavigationController, centerMessageListNavigationController, featuredMessageListNavigationController]
  }
  
  
}
