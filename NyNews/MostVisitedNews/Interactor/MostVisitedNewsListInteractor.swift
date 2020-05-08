//
//  NewsListInteractor.swift
//  NyTimes
//
//  Created by APPLE on 30/04/20.
//  Copyright © 2020 Isha Ramdasi. All rights reserved.
//

import Foundation
import CoreData

protocol MostVisitedNewsListInteractorProtocol: class {
    init(news: [NewsList])
    
    var newsList: [NewsList] { get }
    var newsDidChange: ObserverSet<Void> { get }
    func fetchNews(completionHandler: @escaping (Any?, String?) -> Void)
}

/*
Interactor is responsible for notifying view model about any changes in the values of variables. Data either from database or API is fetched by interactor
*/
final class MostVisitedNewsListInteractor: MostVisitedNewsListInteractorProtocol {
    
    var newsDidChange = ObserverSet<Void>()
    
    private(set) var newsList: [NewsList] {
        didSet {
            newsDidChange.notify(())
        }
    }
    
    init(news: [NewsList]) {
        self.newsList = news
    }

    /*
     Fetch news from API
     */
    func fetchNews(completionHandler: @escaping (Any?, String?) -> Void) {
        MostVisitedNewsAPI.service.getListOfMostVisitedNews { (data, error) in
            self.newsList = NewsCoreDataManager.sharedInstance.fetchAllNews()
            completionHandler(data, error)
        }
    }
}
