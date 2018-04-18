//
//  FirebaseUtils.swift
//  InstagramFirebase
//
//  Created by Abhishesh Pradhan on 16/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import Foundation
import Firebase

extension Database{
    
    //used completion block
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()){
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            
            let user = User(uid: uid, dictionary: userDictionary)
            
            completion(user)
            
            
            //       self.fetchPostsWithUser(user: user)
        }) { (err) in
            print("Failed to fetch user for posts:", err)
        }
    }
    
    
}
