//
//  NewsDetailsInteractor.swift
//  NyNews
//
//  Created by APPLE on 06/05/20.
//  Copyright © 2020 Isha Ramdasi. All rights reserved.
//

import Foundation

protocol NewsDetailsInteractorProtocol: class {
    init(news: NewsList)
    
    var newsDetails: NewsList { get }
    var newsDidChange: ObserverSet<Void> { get }
}

/*
Interactor is responsible for notifying view model about any changes in the values of variables. Data either from database or API is fetched by interactor
*/
final class NewsDetailsInteractor: NewsDetailsInteractorProtocol {
    
    var newsDidChange = ObserverSet<Void>()
    
    private(set) var newsDetails: NewsList {
        didSet {
            newsDidChange.notify(())
        }
    }
    
    init(news: NewsList) {
        self.newsDetails = news
    }
}
