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
    nameLabel.layer.cornerRadius = 9.6
    nameLabel.clipsToBounds = true
  }
  
  private func setDetailView(sermon: Sermon) {
    let contents = Utils.replaced(R.Patterns.mainNameAndDate.rawValue, text: sermon.title, template: "$2|$3").components(separatedBy: "|")
    if let first = contents.first { nameLabel.text = first }
    if let last = contents.last { dateLabel.text = last }
    
    let descriptions = sermon.description.components(separatedBy: "\n").filter { $0.hasPrefix("말씀") || $0.hasPrefix("제목") }
    if let first = descriptions.first { sermonTitleLabel.text = Utils.replaced(R.Patterns.mainTitle.rawValue, text: first, template: "$2") }
    if let last = descriptions.last { scriptLabel.text = Utils.replaced(R.Patterns.mainScript.rawValue, text: last, template: "$2") }
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
      self.setDetailView(sermon: self.dataSource[indexPath])
    }.subscribe().disposed(by: disposeBag)
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
    let contents = Utils.replaced(R.Patterns.mainNameAndDate.rawValue, text: sermon.title, template: "$2|$3|$4")
    cell.configure(thumbnailPath: sermon.imagePath, contents: contents.count > 4 ? contents : "2000.01.01|강태흥 목사|주일예배")
    return cell
  }, configureSupplementaryView: {data, collectionView, text, indexPath in
    return UICollectionReusableView()
  })
}


