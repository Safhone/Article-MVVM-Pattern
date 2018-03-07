//
//  ArticleListViewModel.swift
//  article
//
//  Created by Safhone on 3/5/18.
//  Copyright © 2018 Safhone. All rights reserved.
//

import Foundation
import UIKit

class ArticleListViewModel {
    
    private (set) var articleViewModel: [ArticleViewModel] = [ArticleViewModel]()
    typealias completionHandler = () -> ()
    
    func getArticle(atPage: Int, withLimitation: Int, completion: @escaping completionHandler) {
        DataAccess.manager.fetchData(urlApi: ShareManager.APIKEY.REQUEST_ARICLE, atPage: atPage, withLimitation: withLimitation) { articles in
            self.articleViewModel = articles.map(ArticleViewModel.init)
            completion()
        }
    }
    
}

class ArticleAddViewModel {
    
    func saveArticle(articleViewModel: ArticleViewModel, image: Data) {
        let article = Article(articleViewModel: articleViewModel)
        DataAccess.manager.saveData(urlApi: ShareManager.APIKEY.REQUEST_ARICLE, article: article)
        //DataAccess.manager.saveData(urlApi: ShareManager.APIKEY.REQUEST_ARICLE, article: article, data: image)
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
