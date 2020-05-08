//
//  NewsList.swift
//  NyTimes
//
//  Created by APPLE on 30/04/20.
//  Copyright © 2020 Isha Ramdasi. All rights reserved.
//

import Foundation

struct NewsListModel {
    let newsCategory: NewsCategory
    
    enum NewsCategory {
        case email
        case facebook
        case mostVisited
        
        var localizedString: String {
            switch self {
            case .email:
                return "Email"
            case .facebook:
                return "Facebook"
            case .mostVisited:
                return "Most Visited"
            }
        }
    }
}


