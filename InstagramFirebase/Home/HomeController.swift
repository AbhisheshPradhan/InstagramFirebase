//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Abhishesh Pradhan on 16/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    let cellId = "cellId"
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        setupNavigationItems()
        fetchPosts()
    }
    
    func setupNavigationItems(){
        navigationItem.titleView = UIImageView(image:#imageLiteral(resourceName: "logo2"))
    }
    
    //set the size of the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8 //username + userprofile imageview
        height += view.frame.width //image height
        height += 50    // for action buttons..like, share etc
        height += 60
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    var posts = [Post]()

    fileprivate func fetchPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) {(user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    
    
    fileprivate func fetchPostsWithUser(user: User){
        
      //  guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("posts").child(user.uid)
        
        //does ordering as well
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            //         print(snapshot.key, snapshot.value)
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            let post = Post(user: user, dictionary: dictionary)
            self.posts.insert(post, at: 0)
            
            self.collectionView?.reloadData()
        }) { (err) in
            print("Failed to fetch ordered posts", err)
        }
    }
}
