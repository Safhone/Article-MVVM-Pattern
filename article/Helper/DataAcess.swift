//
//  DataAcess.swift
//  article
//
//  Created by Safhone on 3/6/18.
//  Copyright © 2018 Safhone. All rights reserved.
//

import Foundation
import UIKit

class DataAccess {
    static let manager = DataAccess()
    private init() { }
    
    private enum Methods: String {
        case GET = "GET"
        case POST = "POST"
    }

    private func request(url: URL, method: Methods) -> URLRequest {
        var request = URLRequest(url: url)
        if Methods.GET.rawValue == method.rawValue {
            request.httpMethod = "GET"
        } else if Methods.POST.rawValue == method.rawValue {
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
        
        var request = self.request(url: URL(string: urlApi)!, method: .POST)
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
    
    func uploadImage(urlApi: String, image: Data, completion: @escaping (String) -> ()) {
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: URL(string: urlApi)!)
        request.addValue("application/json",                           forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",                           forHTTPHeaderField: "Accept")
        request.addValue("Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        var formData = Data()
        
        let imageData = image
        let mimeType = "image/jpeg"
        formData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        formData.append("Content-Disposition: form-data; name=\"FILE\"; filename=\"Image.png\"\r\n".data(using: .utf8)!)
        formData.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        formData.append(imageData)
        formData.append("\r\n".data(using: .utf8)!)
        formData.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = formData

        URLSession.shared.uploadTask(with: request, from: formData) { data, response, error in
            if error == nil {
                
                #if DEBUG
                    print("Upload Success")
                #endif
                
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]{
                    let imageUrl = json["DATA"] as! String
                    DispatchQueue.main.async {
                        completion(imageUrl)
                    }
                }
            }
        }.resume()
        
    }
    
}
