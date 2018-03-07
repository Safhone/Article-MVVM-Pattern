//
//  ArticleListViewModel.swift
//  article
//
//  Created by Safhone on 3/5/18.
//  Copyright © 2018 Safhone. All rights reserved.
//

import Foundation
import UIKit

typealias completionHandler = () -> ()

class ArticleListViewModel {
    
    private (set) var articleViewModel: [ArticleViewModel] = [ArticleViewModel]()
    
    func getArticle(atPage: Int, withLimitation: Int, completion: @escaping completionHandler) {
        DataAccess.manager.fetchData(urlApi: ShareManager.APIKEY.RESPONSE_ARICLE, atPage: atPage, withLimitation: withLimitation, type: Article.self) { articles in
            //self.articleViewModel = articles.map(ArticleViewModel.init)
            for article in articles {
                self.articleViewModel.append(ArticleViewModel(title: article.title!, description: article.description!, created_date: (article.created_date?.formatDate(getTime: true))!, image: article.image!))
            }
            completion()
        }
    }
    
}

class ArticleAddViewModel {
    
    private (set) var imageName: String = ""
    
    func saveArticle(articleViewModel: ArticleViewModel) {
        DataAccess.manager.saveData(urlApi: ShareManager.APIKEY.REQUEST_ARICLE, object: Article(articleViewModel: articleViewModel))
    }
    
    func uploadArticle(image: Data, completion: @escaping completionHandler) {
        DataAccess.manager.uploadImage(urlApi: ShareManager.APIKEY.UPLOAD_IMAGE, image: image) { imageName in
            self.imageName = imageName
            completion()
        }
    }
    
}

class ArticleViewModel {
    
    var title       : String?
    var description : String?
    var created_date: String?
    var image       : String?
    
    init(title: String, description: String, created_date: String, image: String) {
        self.title        = title
        self.description  = description
        self.created_date = created_date
        self.image        = image
    }
    
    init(article: Article) {
        self.title        = article.title
        self.description  = article.description
        self.created_date = article.created_date
        self.image        = article.image
    }

}
