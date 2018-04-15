//
//  Post.swift
//  InstagramFirebase
//
//  Created by Abhishesh Pradhan on 15/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import Foundation


struct Post {
    
    
    let imageUrl:String
    
    
    //casting the default value
    init(dictionary: [String : Any]){
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
