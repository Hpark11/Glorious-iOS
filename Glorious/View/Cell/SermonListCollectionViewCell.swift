//
//  SermonListCollectionViewCell.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 15..
//  Copyright © 2017년 church. All rights reserved.
//

import UIKit

class SermonListCollectionViewCell: UICollectionViewCell, NibLoadable {
  
  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    mainView.layer.cornerRadius = 4
    mainView.clipsToBounds = true
  }
  
  public func configure(thumbnailPath: String, name: String, date: String, extra: String = "") {
    if let url = URL(string: thumbnailPath) { imageView.kf.setImage(with: url) }
    mainLabel.text = date + extra
    nameLabel.text = name
  }
}
