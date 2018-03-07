//
//  Constant.swift
//  article
//
//  Created by Vansa Pha on 3/6/18.
//  Copyright © 2018 Safhone. All rights reserved.
//

import Foundation

struct ShareManager {
    static let share = ShareManager()
    private init(){}
    
    struct APIKEY {
        static let REQUEST_ARICLE = "http://api-ams.me/v1/api/articles"
        static let RESPONSE_ARICLE = "http://api-ams.me/v1/api/articles"
        static let UPLOAD_IMAGE = "http://api-ams.me/v1/api/uploadfile/single"
    }
}
