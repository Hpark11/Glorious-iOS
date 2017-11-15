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
  
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var playButton: UIButton!
  
  var viewModel: SermonListViewModel!
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }
  
  internal func bind() {
    viewModel.items.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: self.disposeBag)
    //viewModel.items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.disposeBag)
    
//    playButton.rx.bind(to: viewModel.playAction) { [unowned self] player in
//      self.present(player, animated: false, completion: nil)
//    }
    
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
    
    let pat = "(일산영광교회\\ )([\\D]+)(\\d+\\.\\d+\\.\\d+)([\\w\\ ]*)"
    let regex = try! NSRegularExpression(pattern: pat, options: [])
    let matches = regex.matches(in: sermon.title, options: [], range: NSRange(location: 0, length: sermon.title.count))
    
    let name = regex.stringByReplacingMatches(in: sermon.title, options: [], range: NSRange(location: 0, length: sermon.title.count), withTemplate: "$2")
    let date = regex.stringByReplacingMatches(in: sermon.title, options: [], range: NSRange(location: 0, length: sermon.title.count), withTemplate: "$3")
    let extra = regex.stringByReplacingMatches(in: sermon.title, options: [], range: NSRange(location: 0, length: sermon.title.count), withTemplate: "$4")
    
    cell.configure(thumbnailPath: sermon.imagePath, name: name, date: date, extra: extra.count > 1 ? extra : " 주일예배")
    return cell
  }, configureSupplementaryView: {data, collectionView, text, indexPath in
    return UICollectionReusableView()
  })
  
}
