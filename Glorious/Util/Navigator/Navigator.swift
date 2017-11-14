//
//  Navigator.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 13..
//  Copyright © 2017년 church. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Navigator: NavigatorType {
  private var window: UIWindow
  private var currentViewController: UIViewController
  
  required init(window: UIWindow) {
    self.window = window
    guard let root = window.rootViewController else { fatalError("There is no Root ViewController") }
    currentViewController = root
  }
  
  private func viewController(for viewController: UIViewController) -> UIViewController {
    if let navigationController = viewController as? UINavigationController {
      return navigationController.viewControllers.first!
    } else {
      return viewController
    }
  }
  
  private var navigationController: UINavigationController {
    get {
      guard let nc = currentViewController.navigationController else { fatalError("There is No NavigationController") }
      return nc
    }
  }
  
  func navigate(to stage: Stage, type: Stage.NavigationType) -> Observable<Void> {
    let subject = PublishSubject<Void>()
    let vc = stage.viewController()
    
    switch type {
    case .root:
      self.currentViewController = viewController(for: vc)
      window.rootViewController = vc
      subject.onCompleted()
    case .show(.normal):
      self.navigationController.show(vc, sender: nil)
    case .show(.detail):
      self.navigationController.showDetailViewController(vc, sender: nil)
    case .modal(let modalType):
      if modalType == .popOver { self.currentViewController.modalPresentationStyle = .popover }
      self.currentViewController.present(vc, animated: true, completion: { subject.onCompleted() })
    }
    
    currentViewController = viewController(for: vc)
    return subject.asObservable().take(1)
  }
  
  func revert(animated: Bool) -> Observable<Void> {
    let subject = PublishSubject<Void>()
    if let pc = currentViewController.presentingViewController {
      self.currentViewController.dismiss(animated: animated, completion: {
        self.currentViewController = self.viewController(for: pc)
        subject.onCompleted()
      })
    } else if let nc = currentViewController.navigationController {
      guard nc.popViewController(animated: animated) != nil else { fatalError("Nothing left to go back") }
    } else {
      fatalError("Nothing on current ViewController")
    }
    return subject.asObservable().take(1)
  }
  
}
