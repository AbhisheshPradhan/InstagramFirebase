//
//  Post.swift
//  InstagramFirebase
//
//  Created by Abhishesh Pradhan on 15/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import Foundation


struct Post {
    
    let user: User
    let imageUrl: String
    let caption: String
    
    //casting the default value
    init(user: User, dictionary: [String : Any]){
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
    }
}
