//
//  ArticleViewController.swift
//  article
//
//  Created by Safhone on 3/5/18.
//  Copyright © 2018 Safhone. All rights reserved.
//

import UIKit
import SDWebImage

class NewsViewController: UIViewController {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel      : UILabel!
    @IBOutlet weak var descTextView    : UITextView!
    @IBOutlet weak var dateLabel       : UILabel!
    
    var newsTitle      : String?
    var newsImage      : String?
    var newsDescription: String?
    var newsDate       : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Article"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        if let imgURL = URL(string: newsImage!) {
            articleImageView.sd_setImage(with: imgURL, placeholderImage: #imageLiteral(resourceName: "no-image"))
        }
        
        titleLabel.text   = newsTitle
        descTextView.text = newsDescription
        dateLabel.text    = newsDate
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descTextView.setContentOffset(CGPoint.zero, animated: false)
        
    }

}
