//
//  UICollectionView+Ext.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 15..
//  Copyright © 2017년 church. All rights reserved.
//

import UIKit

extension UICollectionViewCell: Identifiable {}

extension UICollectionView {
  func register<T: UICollectionViewCell>(_: T.Type) where T: NibLoadable {
    let nib = UINib(nibName: T.nibName, bundle: nil)
    register(nib, forCellWithReuseIdentifier: T.identifier)
  }
  
  func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
      fatalError("Unable to dequeue cell with identifier : \(T.identifier)")
    }
    return cell
  }
}
