//
//  NewsListViewModel.swift
//  NyTimes
//
//  Created by APPLE on 30/04/20.
//  Copyright © 2020 Isha Ramdasi. All rights reserved.
//

import Foundation


final class NewsListViewModel {
    
    private let interactor: NewsListInteractorProtocol
    private let coordinator: NewsListCoordinatorProtocol
    var titleArray = ["News", "Videos", "Sports", "Favourites"]

    private var newsList: [NewsList]!
    
    init(interactor: NewsListInteractorProtocol, coordinator: NewsListCoordinatorProtocol) {
        self.interactor = interactor
        self.coordinator = coordinator
    }
    
    func getVisitedNews(completionHandler: @escaping(Any?, String?) -> Void) {
        self.interactor.fetchNews { (data, error) in
            completionHandler(data, error)
        }
    }
    
    func showMostVisitedList(list: [NewsList]) {
        self.coordinator.present(newsList: list)
    }
    
    func getNumberOfSections() -> Int {
        return self.titleArray.count
    }
    
    func getData(row: Int) -> String {
        return titleArray[row]
    }
    
    func getNumberOfFavouriteNews() -> [NewsList] {
        newsList =  interactor.getFavouriteNews()
        return newsList
    }
    
    func data(forRowAt index: Int) -> NewsDataModel {
        let news = newsList[index]
        return NewsDataModel(id: news.id , title: news.title ?? "", abstract: news.abstract ?? "", imgLink: news.imgLink ?? "", url: news.url ?? "")
    }
}
