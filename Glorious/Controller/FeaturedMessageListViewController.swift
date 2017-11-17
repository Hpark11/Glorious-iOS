//
//  FeaturedMessageListViewController.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 15..
//  Copyright © 2017년 church. All rights reserved.
//

import UIKit

class FeaturedMessageListViewController: UIViewController, ViewModelBindable {
  var viewModel: FeaturedMessageListViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  func bind() {
    
    //    tableView.rx.itemSelected.map { [unowned self] indexPath in
    //      let fullscreenVideoPlayer = XCDYouTubeVideoPlayerViewController.init(videoIdentifier: "iOGvPJTsfj4")
    //      self.present(fullscreenVideoPlayer, animated: false, completion: nil)
    //      }.subscribe(onNext: { _ in
    //        print("")
    //      }).disposed(by: disposeBag)
    
    
    //  let dataSource = RxTableViewSectionedAnimatedDataSource<SermonSection>(configureCell: {
    //    data, tableView, indexPath, sermon in
    //    let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SermonTableViewCell
    //    cell.configure(thumbnailPath: sermon.imagePath, title: sermon.title)
    //    return cell
    //  })
  }

}
