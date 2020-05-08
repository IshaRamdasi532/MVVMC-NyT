//
//  NewsListInteractor.swift
//  NyTimes
//
//  Created by APPLE on 30/04/20.
//  Copyright © 2020 Isha Ramdasi. All rights reserved.
//

import Foundation
import CoreData

protocol NewsListInteractorProtocol: class {

    func fetchNews(completionHandler: @escaping (Any?, String?) -> Void)
    func getFavouriteNews() -> [NewsList]
}

/*
Interactor is responsible for notifying view model about any changes in the values of variables. Data either from database or API is fetched by interactor
*/
final class NewsListInteractor: NewsListInteractorProtocol {

    /*
     Fetch news from API
     */
     func fetchNews(completionHandler: @escaping (Any?, String?) -> Void) {
        MostVisitedNewsAPI.service.getListOfMostVisitedNews { (data, error) in
            completionHandler(data, error)
        }
    }
    
    /*
     Fetch favourite news from database
     */
    func getFavouriteNews() -> [NewsList] {
        NewsCoreDataManager.sharedInstance.fetchFavouriteNews()
    }
}
