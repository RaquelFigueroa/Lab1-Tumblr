//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Raquel Figueroa-Opperman on 1/31/18.
//  Copyright © 2018 JY. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //property to store posts:
    var posts: [[String: Any]] = []
    
    @IBOutlet weak var imageView: UITableView!
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PhotosViewController.didPullToRefresh(_:)), for: .valueChanged)
        
        imageView.insertSubview(refreshControl, at: 0)
        imageView.dataSource = self
        
        imageView.delegate = self
        
        
        fetchImages()
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchImages()
    }

    func fetchImages(){
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                if (error.localizedDescription == "The Internet connection appears to be offline."){
                        //alert functionality:
                        let alertController = UIAlertController(title: "Network Connection Failure", message: "The Internet connection appears to be offline. Would you like to reload?", preferredStyle: .alert)
                    
                        let cancelAction = UIAlertAction(title: "Cancel: Exit App", style: .cancel) { (action) in
                            exit(0)
                        }
                    
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            self.fetchImages()
                        }
                    
                        alertController.addAction(cancelAction)
                        alertController.addAction(okAction)
                    
                        self.present(alertController, animated: true){
                    }
                }
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                
                // TODO: Get the posts and store in posts property
                let posts = responseDictionary["posts"] as! [[String: Any]]
                self.posts = posts
                
                // TODO: Reload the table view
                self.imageView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = imageView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! PhotoCell

        let post = posts[indexPath.section]

        if let photos = post["photos"] as? [[String: Any]] {
            // photos is NOT nil, we can use it!
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String: Any]
            let urlString = originalSize["url"] as! String
            let url = URL(string: urlString)!

            cell.photoImageView.af_setImage(withURL: url)
            
//            cell.photoDateLabel.text = "date"
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = imageView.indexPath(for: cell) {
            let post = posts[indexPath.section]
            let vc = segue.destination as! PhotoDetailsViewController
            vc.photoDetail = post
        }
    }
    
    //header view:
    func numberOfSections(in imageView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        let post = posts[section]
        
        // Set the avatar
        profileView.af_setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
        headerView.addSubview(profileView)
        
        let label = UILabel(frame: CGRect(x: 50, y: 10, width: 250, height: 30))
        let date = post["date"] as! String
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'GMT'"
        let newDate = formatter.date(from: date)

        formatter.dateFormat = "MMMM d, yyyy h:mm a"
        let dateStr = formatter.string(from: newDate!)

        label.text = dateStr

        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
