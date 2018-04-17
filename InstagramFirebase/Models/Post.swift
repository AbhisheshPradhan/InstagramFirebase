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
    let creationDate: Date
    
    
    //casting the default value
    init(user: User, dictionary: [String : Any]){
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
