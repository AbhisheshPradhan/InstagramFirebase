//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by Abhishesh Pradhan on 15/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String){
        lastURLUsedToLoadImage = urlString
        
        self.image = nil
        
        //if the image is already is in the cache, just return that image from the cache instead of fetching again
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to open the image url", err)
            }
            
            // no repeats
            //since url session is done asynchronously, the order of images loading is not absolute.
            //this makes sure the image you want is the image you are getting essentially
            if url.absoluteString != self.lastURLUsedToLoadImage{
                return
            }
            
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            
            
            //cache the images into the image cache..save data..reduce unnecessary fetching of data again
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            }.resume()      //always must have resume in url sessions
    }
}
