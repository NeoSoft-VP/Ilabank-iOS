//
//  PhotoViewModel.swift
//  Ilabank-iOS
//
//  Created by Neosoft on 06/06/22.
//

import UIKit

class PhotoViewModel: NSObject {
    
    // callbacks for a web request
    var reloadTableView: (()->())?
    var showLoading: (()->())?
    var hideLoading: (()->())?
    
    // prepares data w.r.t indexes
    var slideData = [(index: Int, data: [Photo])]()
    var filterPhotos = [Photo]()
    var photos : [Photo]?
    var error: String?
    var isSearching = false
    var webService = WebServices()
    
    override init() {
        super.init()
        
        // get latest photos from API
        requestPhotosFromAPI()
    }
    
    private func requestPhotosFromAPI() {
        
        // show loader
        self.showLoading?()
        
        // request a data from URI
        webService.requestGet { response in
            if let error = response.error {
                DispatchQueue.main.async {
                    self.error = error
                    self.hideLoading?()
                }
            } else if let photos = response.photos {
                self.photos = photos
                DispatchQueue.main.async {
                    
                    self.error = nil
                    
                    let slide1Data = self.searchBy("Velit")
                    self.slideData.append((index: 0, data: slide1Data))
                    
                    let slide2Data = self.searchBy("Ipsam")
                    self.slideData.append((index: 1, data: slide2Data))
                    
                    let slide3Data = self.searchBy("fuga")
                    self.slideData.append((index: 2, data: slide3Data))
                    
                    self.photos = slide1Data
                    self.hideLoading?()
                    self.reloadTableView?()
                }
            }
        }
        
    }
    
    // Sort photo with respect to title
    func searchBy(_ title: String) -> [Photo] {
        self.photos?.filter { $0.title?.lowercased().contains(title.lowercased()) ?? false } ?? [Photo]()
    }
}
