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
  
  @IBOutlet weak var scriptLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var sermonTitleLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var dividerView: UIView!
  
  var viewModel: CenterMessageListViewModel!
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
    
    if let first = sermon.description.components(separatedBy: ",").first {
      let text = Utils.replaced(R.Patterns.name.rawValue, text: first, template: "$2")
      nameLabel.text = text.count > 2 ? text : "Rev. Kwang Su Ryu"
    }
    
    if sermon.title.hasPrefix("201") {
      var data = Utils.replaced(R.Patterns.centerMessageN.rawValue, text: sermon.title, template: "$1.$2.$3|$4").components(separatedBy: "|")
      if let last = data.last {
        var replaced: String = ""
        switch last.lowercased() {
        case "h": replaced = "핵심예배"
        case "biz": replaced = "산업선교"
        case "g": replaced = "구역예배"
        case "a": replaced = "주일 1부"
        case "b": replaced = "주일 2부"
        default: break
        }
        
        data[data.endIndex - 1] = replaced
      }
      
      if data.count >= 2 {
        dateLabel.text = data.removeFirst()
        sermonTitleLabel.text = data.removeFirst()
        scriptLabel.text = data.count > 0 ? data.last! : ""
      }
    } else {
      var data = Utils.replaced(R.Patterns.centerMessage.rawValue, text: sermon.title, template: "$3.$1.$2|$6|$7").components(separatedBy: "|")
      if data.count >= 2 {
        dateLabel.text = data.removeFirst()
        sermonTitleLabel.text = data.removeFirst()
        scriptLabel.text = data.count > 0 ? data.last! : ""
      }
    }
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
    
    if sermon.title.hasPrefix("201") {
      let name = "Rev. Kwang Su Ryu"
      var data = Utils.replaced(R.Patterns.centerMessageN.rawValue, text: sermon.title, template: "\(name)|$1.$2.$3|$4").components(separatedBy: "|")
      if let last = data.last {
        var replaced: String = ""
        switch last.lowercased() {
        case "h": replaced = "핵심예배"
        case "biz": replaced = "산업선교"
        case "g": replaced = "구역예배"
        case "a": replaced = "주일 1부"
        case "b": replaced = "주일 2부"
        default: break
        }
        
        data[data.endIndex - 1] = replaced
      }
      let contents = data.joined(separator: "|")
      cell.configure(thumbnailPath: sermon.imagePath, contents: contents.count > 4 ? contents : "Rev. Kwang Su Ryu|2000.01.01|주일예배")
    } else {
      let name = Utils.replaced(R.Patterns.name.rawValue, text: sermon.description.components(separatedBy: ",").first!, template: "$2")
      var data = Utils.replaced(R.Patterns.centerMessage.rawValue, text: sermon.title, template: "\(name)|$3.$1.$2|$4").components(separatedBy: "|")
      if let last = data.last {
        var replaced: String = ""
        switch last.lowercased() {
        case "core": replaced = "핵심예배"
        case "biz": replaced = "산업선교"
        case "district": replaced = "구역예배"
        case "1st": replaced = "주일 1부"
        case "2nd": replaced = "주일 2부"
        default: break
        }
        
        data[data.endIndex - 1] = replaced
      }
      let contents = data.joined(separator: "|")
      cell.configure(thumbnailPath: sermon.imagePath, contents: contents.count > 4 ? contents : "Rev. Kwang Su Ryu|2000.01.01|주일예배")
    }
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
