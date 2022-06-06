//
//  ImageDetailTableViewCell.swift
//  Ilabank-iOS
//
//  Created by Neosoft on 06/06/22.
//

import UIKit

class ImageDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func prepareCell(with model: PhotoViewModel, at indexPath: IndexPath) {
        // prepare cell data w.r.t to searching condition
        if let photos = model.isSearching ? model.filterPhotos : model.photos {
            let photo = photos[indexPath.row]
            self.title.text = photo.title ?? ""
            self.desc.text = "Album identifier \((photo.albumId ?? 0))"
            
            let imagePath = photo.thumbnailUrl ?? ""
            self.imageViewIcon.downloadImage(from: imagePath, with: { response in
                if response.status {
                    DispatchQueue.main.async {
                        self.imageViewIcon.image = response.image
                    }
                } else {
                    DispatchQueue.main.async {
                        self.imageViewIcon.image = UIImage(systemName: "square.and.arrow.up")
                    }
                }
            })
        }
    }
}

