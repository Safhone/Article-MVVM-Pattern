//
//  Article.swift
//  article
//
//  Created by Safhone on 3/5/18.
//  Copyright © 2018 Safhone. All rights reserved.
//

import Foundation


struct Article: Codable {
    
    var id          : Int?
    var title       : String?
    var description : String?
    var created_date: String?
    var image       : String?
    
    private enum CodingKeys: String, CodingKey {
        case id             = "ID"
        case title          = "TITLE"
        case description    = "DESCRIPTION"
        case created_date   = "CREATED_DATE"
        case image          = "IMAGE"
    }
    
    init(articleViewModel: ArticleViewModel) {
        self.id             = articleViewModel.id
        self.title          = articleViewModel.title
        self.description    = articleViewModel.description
        self.created_date   = articleViewModel.created_date
        self.image          = articleViewModel.image
    }

}
