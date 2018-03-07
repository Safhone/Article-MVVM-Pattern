//
//  DataAcess.swift
//  article
//
//  Created by Vansa Pha on 3/6/18.
//  Copyright © 2018 Safhone. All rights reserved.
//

import Foundation
import Alamofire

class DataAccess {
    static let manager = DataAccess()
    private init() { }
    
    private enum Methods: String {
        case GET = "GET"
        case POST = "POST"
    }

    private func request(url: URL, method: Methods) -> URLRequest {
        var request = URLRequest(url: url)
        if Methods.GET.rawValue == "GET" {
            request.httpMethod = "GET"
        } else if Methods.POST.rawValue == "POST" {
            request.httpMethod = "POST"
        }
        
        request.addValue("application/json",                           forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",                           forHTTPHeaderField: "Accept")
        request.addValue("Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func fetchData(urlApi: String, atPage: Int, withLimitation: Int, completion: @escaping ([Article]) -> ()) {
    
        let url = URL(string: "\(urlApi)?page=\(atPage)&limit=\(withLimitation)")!
        URLSession.shared.dataTask(with: request(url: url, method: .GET)) { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(Response<Article>.self, from: data)
                    let article = response.DATA
                    DispatchQueue.main.async {
                        completion(article)
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    
    func saveData(urlApi: String, article: Article) {
        let articleData = try? JSONEncoder().encode(article)
        
        var request = URLRequest(url: URL(string: urlApi)!)
        request.addValue("application/json",                           forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",                           forHTTPHeaderField: "Accept")
        request.addValue("Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = articleData
        
        #if DEBUG
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8)!)
        #endif
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {
                if let error = error as NSError? {
                    print(error)
                }
                return
            }
        }.resume()
        
    }
    
//    var headers = [
//        "Content-Type": "Application/json",
//        "Accept" : "application/json",
//        "Authorization": "Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ="
//    ]
    
    
    
//    func saveData(urlApi: String, article: Article, data: Data) {
//
//        Alamofire.upload(multipartFormData: { (multipart) in
//            multipart.append(data, withName: "FILE", fileName: ".jpg", mimeType: "image/jpeg")
//        }, to: ShareManager.APIKEY.UPLOAD_IMAGE, method: .post, headers: headers) { encoding in
//            switch encoding {
//            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
//                upload.responseJSON(completionHandler: { (response) in
//                    if let data = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String:Any] {
//                        let article: Article = article
//                        article.image = data["DATA"] as? String
//
//                        let parameters: Parameters = [
//                            "TITLE" : article.title!,
//                            "DESCRIPTION" : article.description!,
//                            "IMAGE" : article.image!
//                            ]
//                        Alamofire.request(urlApi, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers).responseJSON { response in
//                            if response.result.isSuccess {
//                                print("Saved Success")
//                            }
//                        }
//                    }
//                })
//            case .failure(let error):
//                print("Error: \(error.localizedDescription)")
//            }
//        }
//
//    }
    
    
}
