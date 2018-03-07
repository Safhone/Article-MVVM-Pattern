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
    
    private (set) var imageName: String = ""
    private (set) var articleViewModel: [ArticleViewModel] = [ArticleViewModel]()
    
    func getArticle(atPage: Int, withLimitation: Int, completion: @escaping completionHandler) {
        DataAccess.manager.fetchData(urlApi: ShareManager.APIKEY.ARTICLE, atPage: atPage, withLimitation: withLimitation, type: Article.self) { articles in
            self.articleViewModel = articles.map(ArticleViewModel.init)
            completion()
        }
    }
    
    func saveArticle(articleViewModel: ArticleViewModel) {
        DataAccess.manager.saveData(urlApi: ShareManager.APIKEY.ARTICLE, object: Article(articleViewModel: articleViewModel))
    }
    
    func updateArticle(articleViewModel: ArticleViewModel, id: Int) {
        DataAccess.manager.updateArticle(urlApi: ShareManager.APIKEY.ARTICLE, object: Article(articleViewModel: articleViewModel), id: id)
    }
    
    func uploadArticle(image: Data, completion: @escaping completionHandler) {
        DataAccess.manager.uploadImage(urlApi: ShareManager.APIKEY.UPLOAD_IMAGE, image: image) { imageName in
            self.imageName = imageName
            completion()
        }
    }
    
    func deleteArticle(id: Int) {
        DataAccess.manager.deleteData(urlApi: ShareManager.APIKEY.ARTICLE, id: id)
    }
    
}

class ArticleViewModel {
    
    var id          : Int?
    var title       : String?
    var description : String?
    var created_date: String?
    var image       : String?
    
    init(id: Int, title: String, description: String, created_date: String, image: String) {
        self.id           = id
        self.title        = title
        self.description  = description
        self.created_date = created_date
        self.image        = image
    }
    
    init(article: Article) {
        self.id           = article.id
        self.title        = article.title
        self.description  = article.description
        self.created_date = article.created_date?.formatDate(getTime: true)
        self.image        = article.image
    }

}
