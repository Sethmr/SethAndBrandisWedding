//
//  CloudinaryService.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

import UIKit
import Cloudinary

class CloudinaryService {

    static let cloudName: String = "sethandbrandi"
    static let apiKey: String = "153455974671387"
    static let apiSecret: String = "TYHO8Tt0g-pqE1wkZLqBuwuenJ4"
    static let configuration = CLDConfiguration(cloudName: cloudName, apiKey: apiKey, apiSecret: apiSecret)
    static let cloudinary = CLDCloudinary(configuration: configuration)

    static func upload(data: Data, completion: @escaping ((String?)->())) {
        var params: CLDUploadRequestParams?
        if let name = ViewController.name {
            params = CLDUploadRequestParams().setTags(name)
        }
        cloudinary.createUploader().signedUpload(data: data, params: params) { result, error in
            guard let result = result else {
                print(error?.localizedDescription ?? "Error: Nil")
                completion(nil)
                return
            }
            completion(result.url)
        }
    }

}
