//
//  ImageCache.swift
//  RachioService
//
//  Created by Roderic Campbell on 4/16/19.
//  Copyright © 2019 Thumbworks. All rights reserved.
//

import Foundation

class ImageCache: NSObject {
    let imageCache = NSCache<AnyObject, AnyObject>()

    let queue = OperationQueue()
    func image(at urlString: String, onComplete: @escaping (UIImage?, Error?) -> ()) {
        if let image = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            onComplete(image, nil)
            return
        }
        queue.addOperation {
            guard let URL = URL(string: urlString) else {
                return
            }
            do {
                let data = try Data(contentsOf: URL)
                if let image = UIImage(data: data) {
                    self.imageCache.setObject(image, forKey: urlString as AnyObject)
                    onComplete(image, nil)
                }
            } catch {
                print("Error fetching image \(error)")
                onComplete(nil, error)
            }
        }
    }
}
