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
    case secondPage
    case lastPage

    static let allTypes: [OnboardingType] = [.firstPage, .secondPage, .lastPage]

    var image: UIImage {
        switch self {
        case .firstPage:
            return #imageLiteral(resourceName: "FirstPage")
        case .secondPage:
            return #imageLiteral(resourceName: "SecondPage")
        case .lastPage:
            return #imageLiteral(resourceName: "LastPageBackground")
        }
    }
}
