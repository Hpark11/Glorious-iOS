//
//  SermonListViewController.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 13..
//  Copyright © 2017년 church. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import XCDYouTubeKit
import Action

class SermonListViewController: UIViewController, ViewModelBindable {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var sermonTitleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var scriptLabel: UILabel!
  
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var playButton: UIButton!
  
  var viewModel: SermonListViewModel!
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    initView()
  }
  
  private func initView() {
    nameLabel.layer.cornerRadius = 7.2
    nameLabel.clipsToBounds = true
  }
  
  internal func bind() {
    viewModel.items.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: self.disposeBag)
    
    playButton.rx.bind(to: viewModel.playAction) { [unowned self] _ in
      let fullscreenVideoPlayer = XCDYouTubeVideoPlayerViewController.init(videoIdentifier: self.viewModel.videoId)
      self.present(fullscreenVideoPlayer, animated: false, completion: nil)
    }
    
    collectionView.rx.itemSelected.map { [unowned self] indexPath in
      if let url = URL(string: self.dataSource[indexPath].imagePath) {self.mainImageView.kf.setImage(with: url)}
      self.viewModel.videoId = self.dataSource[indexPath].videoId
      }.subscribe(onNext: { _ in
        print("")
      }).disposed(by: disposeBag)
  }
  
  private func configure() {
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
      layout.minimumLineSpacing = 0
      layout.itemSize = CGSize(width: collectionView.frame.width / 5 * 2.32, height: collectionView.frame.height)
    }
    
    collectionView.register(SermonListCollectionViewCell.self)
  }
  
  let dataSource = RxCollectionViewSectionedAnimatedDataSource<SermonSection>(configureCell: {
    data, collectionView, indexPath, sermon in
    let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SermonListCollectionViewCell
    
    do {
      let pat = "(일산영광교회\\ )([\\D]+)(\\d+\\.\\d+\\.\\d+)([\\w\\ ]*)"
      let regex = try NSRegularExpression(pattern: pat, options: [])
      let contents = regex.stringByReplacingMatches(in: sermon.title, options: [], range: NSRange(location: 0, length: sermon.title.count), withTemplate: "$2|$3|$4")
      cell.configure(thumbnailPath: sermon.imagePath, contents: contents)
    } catch {
      cell.configure(thumbnailPath: sermon.imagePath, contents: "2000.01.01|강태흥 목사|주일예배")
    }
    return cell
  }, configureSupplementaryView: {data, collectionView, text, indexPath in
    return UICollectionReusableView()
  })
  
}
