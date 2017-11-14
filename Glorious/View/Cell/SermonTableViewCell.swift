//
//  SermonTableViewCell.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 13..
//  Copyright © 2017년 church. All rights reserved.
//

import UIKit
import Kingfisher

class SermonTableViewCell: UITableViewCell, NibLoadable {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var thumbnailImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  public func configure(thumbnailPath: String, title: String) {
    if let url = URL(string: thumbnailPath) { thumbnailImageView.kf.setImage(with: url) }
    titleLabel.text = title
  }
}
