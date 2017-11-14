//
//  UITableView+Ext.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 14..
//  Copyright © 2017년 church. All rights reserved.
//

import UIKit

extension UITableViewCell: Identifiable {}

extension UITableView {
  func register<T: UITableViewCell>(_: T.Type) where T: NibLoadable {
    let nib = UINib(nibName: T.nibName, bundle: nil)
    register(nib, forCellReuseIdentifier: T.identifier)
  }
  
  func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
      fatalError("Unable to dequeue cell with identifier : \(T.identifier)")
    }
    return cell
  }
}

