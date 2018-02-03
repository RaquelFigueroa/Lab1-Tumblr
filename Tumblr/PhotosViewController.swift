//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Raquel Figueroa-Opperman on 1/31/18.
//  Copyright © 2018 JY. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    //property to store posts:
    var posts: [[String: Any]] = []
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                //print(dataDictionary)
                
                
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                
                // TODO: Get the posts and store in posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                print (self.posts)
                // TODO: Reload the table view
                
            }
        }
        task.resume()
    }

    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
