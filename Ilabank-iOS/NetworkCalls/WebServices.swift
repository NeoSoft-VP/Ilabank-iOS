//
//  WebServices.swift
//  Ilabank-iOS
//
//  Created by Neosoft on 06/06/22.
//

import Foundation

class WebServices :  NSObject {
    
    private let sourcesURL = URL(string: "https://jsonplaceholder.typicode.com/photos")!
    
    func requestGet(photos completion : @escaping ((photos: [Photo]?, error: String?)) -> ()){
        URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
            if let data = data {
                
                let jsonDecoder = JSONDecoder()
                
                do {
                    // convert data bytes to original Model class
                    let response = try jsonDecoder.decode([Photo].self, from: data)
                    completion((photos: response, error: nil))
                } catch let error {
                    // handle error if any
                    print(error.localizedDescription)
                    completion((photos: nil, error: error.localizedDescription))
                }

            }
        }.resume()
    }
}
