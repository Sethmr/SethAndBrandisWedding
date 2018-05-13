//
//  OnboardingType.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

import Foundation

enum OnboardingType: Int {
    case firstPage
    case lastPage

    static let allTypes: [OnboardingType] = [.firstPage, .lastPage]

    var image: UIImage {
        switch self {
        case .firstPage:
            return UIImage()
        case .lastPage:
            return #imageLiteral(resourceName: "LastPageBackground")
        }
    }
}
