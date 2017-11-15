//
//  CenterMessageViewController.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 15..
//  Copyright © 2017년 church. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import XCDYouTubeKit

class CenterMessageListViewController: UIViewController, ViewModelBindable {
  @IBOutlet weak var tableView: UITableView!
  
  var viewModel: CenterMessageListViewModel!
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }
  
  internal func bind() {
    viewModel.items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.disposeBag)

    tableView.rx.itemSelected.map { [unowned self] indexPath in
      let fullscreenVideoPlayer = XCDYouTubeVideoPlayerViewController.init(videoIdentifier: "iOGvPJTsfj4")
      self.present(fullscreenVideoPlayer, animated: false, completion: nil)
      }.subscribe(onNext: { _ in
        print("")
      }).disposed(by: disposeBag)
  }
  
  private func configure() {
    tableView.register(SermonTableViewCell.self)
    tableView.estimatedRowHeight = view.frame.size.height / 3 * 1
    tableView.separatorStyle = .none
  }
  
  let dataSource = RxTableViewSectionedAnimatedDataSource<SermonSection>(configureCell: {
    data, tableView, indexPath, sermon in
    let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SermonTableViewCell
    cell.configure(thumbnailPath: sermon.imagePath, title: sermon.title)
    return cell
  })
}