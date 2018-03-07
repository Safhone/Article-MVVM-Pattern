//
//  ArticleViewController.swift
//  article
//
//  Created by Safhone on 3/5/18.
//  Copyright © 2018 Safhone. All rights reserved.
//

import UIKit

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
            articleImageView.kf.setImage(with: imgURL, placeholder: #imageLiteral(resourceName: "no-image"), options: nil, progressBlock: nil, completionHandler: nil)
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
