//
//  MainSplashViewController.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 17..
//  Copyright © 2017년 church. All rights reserved.
//

import UIKit

class MainSplashViewController: UIViewController, UIViewControllerTransitioningDelegate {
  
  let animator = StretchingAnimator()
  lazy var alert: UIAlertController = UIAlertController(title: "접속 오류", message: "인터넷 연결을 확인하시고 다시 시도해주세요", preferredStyle: .alert)
  lazy var retry: UIAlertAction = UIAlertAction(title: "확인", style: .default, handler: { [unowned self] _ in self.check() })
  //lazy var cancel: UIAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    alert.addAction(retry)
    check()
  }
  
  private func check() {
    APIService.checkAvailability { [unowned self] isSuccess in
      if isSuccess {
        self.performSegue(withIdentifier: R.Segues.initSegue.rawValue, sender: nil)
      } else {
        self.present(self.alert, animated: true, completion: nil)
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? MainTabBarController {
      vc.transitioningDelegate = self
      vc.modalPresentationStyle = .custom
    }
  }
  
  func setAnimator(mode: StretchingAnimator.TransitionMode) -> UIViewControllerAnimatedTransitioning? {
    animator.transitionMode = mode
    animator.origin = view.center
    animator.circleColor = UIColor.clear
    return animator
  }
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return setAnimator(mode: .present)
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return setAnimator(mode: .dismiss)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}
