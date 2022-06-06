//
//  CorousalTableViewCell.swift
//  Ilabank-iOS
//
//  Created by Neosoft on 06/06/22.
//

import UIKit

protocol CorousalProtocol {
    func slide(with index: Int)
}

class CorousalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    var delegate: CorousalProtocol?
    var arrImage = ["page1", "page2", "page3"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.size.width, height: 220)
            flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: 220)
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
}

extension CorousalTableViewCell: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag == 101 {
            let pageWidth = scrollView.frame.size.width
            let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
            self.pageControl.currentPage = page
            if let delegate = self.delegate {
                delegate.slide(with: page)
            }
        }
    }
}

extension CorousalTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 16, height: 220 - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCorousalCell", for: indexPath) as! ImagesCollectionViewCell
        
        let imageName = arrImage[indexPath.row]
        cell.imageView.image = UIImage(named: imageName)
        
        return cell
    }
    
}

