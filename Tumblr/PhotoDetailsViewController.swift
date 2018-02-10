//
//  PhotoDetailsViewController.swift
//  Tumblr
//
//  Created by Raquel Figueroa-Opperman on 2/9/18.
//  Copyright © 2018 JY. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    
    var url: [String: Any]?
    var photoDetail: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let photoDetail = photoDetail {
            let photos = photoDetail["photos"]  as? [[String: Any]]
            let photo = photos![0]
            let originalSize = photo["original_size"] as! [String: Any]
            let urlString = originalSize["url"] as! String
            let imageURL = URL(string: urlString)!
            
            photoImageView.af_setImage(withURL: imageURL)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
