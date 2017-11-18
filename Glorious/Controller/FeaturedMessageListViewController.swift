//
//  FeaturedMessageListViewController.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 15..
//  Copyright © 2017년 church. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import XCDYouTubeKit

class FeaturedMessageListViewController: UIViewController, ViewModelBindable {
  @IBOutlet weak var tableView: UITableView!
  
  let disposeBag = DisposeBag()
  var viewModel: FeaturedMessageListViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }
  
  func bind() {
    viewModel.items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.disposeBag)
    
    tableView.rx.itemSelected.map { [unowned self] indexPath in
      let fullscreenVideoPlayer = XCDYouTubeVideoPlayerViewController.init(videoIdentifier: self.dataSource[indexPath].videoId)
      self.present(fullscreenVideoPlayer, animated: false, completion: nil)
      self.tableView.deselectRow(at: indexPath, animated: false)
    }.subscribe().disposed(by: disposeBag)
  }
  
  private func configure() {
    tableView.register(SermonTableViewCell.self)
  }
  
  let dataSource = RxTableViewSectionedAnimatedDataSource<SermonSection>(configureCell: {
    data, tableView, indexPath, sermon in
    let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SermonTableViewCell
    var title = ""
    
    switch (indexPath.row, indexPath.section) {
    case (0, 0): title = "62가지"
    case (1, 0): title = "구원의 길"
    case (2, 0): title = "1분 구원의 길"
    case (3, 0): title = "3분 구원의 길"
    case (4, 0): title = "5분 구원의 길"
    default: break
    }
    
    cell.configure(thumbnailPath: sermon.imagePath, title: title)
    return cell
  })
  
}
