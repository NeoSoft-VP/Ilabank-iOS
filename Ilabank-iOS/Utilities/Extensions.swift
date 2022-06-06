//
//  Extensions.swift
//  Ilabank-iOS
//
//  Created by Neosoft on 06/06/22.
//

import Foundation
import UIKit

 
extension UIImageView {
    // return image sttatus w.r.t URLs
    func downloadImage(from URLString: String, with completion: @escaping (_ response: (status: Bool, image: UIImage? ) ) -> Void) {
        ImageDownloader.shared.downloadImage(from: URLString, with: completion)
    }
}

extension UIViewController {
    // alert extension for ViewConttrollers
    func showAlert(with title: String, and message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel) { action in
            controller.dismiss(animated: true, completion: nil)
        }
        
        controller.addAction(action)
        
        present(controller, animated: true, completion: nil)
    }
}
