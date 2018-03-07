//
//  ArticleTableViewCell.swift
//  article
//
//  Created by Safhone on 3/5/18.
//  Copyright © 2018 Safhone. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(articleViewModel: ArticleViewModel) {
        articleTitleLabel.text = articleViewModel.title
        articleDateLabel.text = articleViewModel.created_date?.formatDate(getTime: true)
        
        if let imgURL = URL(string: articleViewModel.image!) {
            articleImageView.sd_setImage(with: imgURL, placeholderImage: #imageLiteral(resourceName: "no-image"))
        }
        
    }

}
