//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Raquel Figueroa-Opperman on 1/31/18.
//  Copyright © 2018 JY. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController, UITableViewDataSource {
    
    //property to store posts:
    var posts: [[String: Any]] = []
    
    @IBOutlet weak var imageView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.dataSource = self
        fetchImages()

    }

    func fetchImages(){
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                
                // TODO: Get the posts and store in posts property
                let posts = responseDictionary["posts"] as! [[String: Any]]
                self.posts = posts

                

                //let photoURL =
                //print (self.posts)
                
                // TODO: Reload the table view
                self.imageView.reloadData()
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = imageView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! PhotoCell

        let imageURL = URL(string: "https://78.media.tumblr.com/a2f23071e45e327326a2b84994719ffb/tumblr_p3g83tzRjp1qggwnvo1_500.jpg")!
        cell.photoImageView.af_setImage(withURL: imageURL)
        
        return cell
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
