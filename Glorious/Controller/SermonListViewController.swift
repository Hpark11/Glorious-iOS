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
  @IBOutlet weak var dividerView: UIView!
  
  var viewModel: SermonListViewModel!
  var isDirectlyPlayable = UIDevice.current.orientation.isLandscape
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
    playButton.isHidden = false
    nameLabel.isHidden = false
    dividerView.isHidden = false
    
    if let url = URL(string: sermon.imagePath) {self.mainImageView.kf.setImage(with: url)}
    self.viewModel.videoId = sermon.videoId
    
    let contents = Utils.replaced(R.Patterns.mainNameAndDate.rawValue, text: sermon.title, template: "$2|$3").components(separatedBy: "|")
    if let first = contents.first { nameLabel.text = first }
    if let last = contents.last { dateLabel.text = last }
    
    let descriptions = sermon.description.components(separatedBy: "\n").filter { $0.hasPrefix("말씀") || $0.hasPrefix("제목") }
    if let first = descriptions.first { sermonTitleLabel.text = Utils.replaced(R.Patterns.mainTitle.rawValue, text: first, template: "$2") }
    if let last = descriptions.last { scriptLabel.text = "(\(Utils.replaced(R.Patterns.mainScript.rawValue, text: last, template: "$2")))" }
  }
  
  private func showPlayer() {
    let fullscreenVideoPlayer = XCDYouTubeVideoPlayerViewController.init(videoIdentifier: self.viewModel.videoId)
    self.present(fullscreenVideoPlayer, animated: false, completion: nil)
  }
  
  internal func bind() {
    viewModel.items.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: self.disposeBag)
    
    viewModel.initSermon.asObservable().subscribe(onNext: { [unowned self] sermon in
      self.setDetailView(sermon: sermon)
    }).disposed(by: disposeBag)
    
    playButton.rx.bind(to: viewModel.playAction) { [unowned self] _ in
      self.showPlayer()
    }
    
    collectionView.rx.itemSelected.map { [unowned self] indexPath in
      self.setDetailView(sermon: self.dataSource[indexPath])
      if self.isDirectlyPlayable { self.showPlayer() }
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
    cell.configure(thumbnailPath: sermon.imagePath, contents: contents.count > 4 ? contents : "강태흥 목사|2000.01.01|주일예배")
    return cell
  }, configureSupplementaryView: {data, collectionView, text, indexPath in
    return UICollectionReusableView()
  })
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    hidePreview(isDirectlyPlayable)
  }
  
  private func hidePreview(_ isHidden: Bool) {
    mainImageView.isHidden = isHidden
    playButton.isHidden = isHidden
    dividerView.isHidden = isHidden
    dateLabel.isHidden = isHidden
    scriptLabel.isHidden = isHidden
    nameLabel.isHidden = isHidden
    isDirectlyPlayable = isHidden
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    if UIDevice.current.orientation.isPortrait {
      hidePreview(false)
    } else {
      if size.width <= 740 { hidePreview(true) }
      else { hidePreview(false) }
    }
  }
}


