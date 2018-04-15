//
//  PhotoSelectorCell.swift
//  InstagramFirebase
//
//  Created by Abhishesh Pradhan on 15/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit


class PhotoSelectorCell: UICollectionViewCell{
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill //better content mode for images in cells
        iv.clipsToBounds = true //clip the image within the bounds of the cell
        iv.backgroundColor = .lightGray
        return iv
        
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
