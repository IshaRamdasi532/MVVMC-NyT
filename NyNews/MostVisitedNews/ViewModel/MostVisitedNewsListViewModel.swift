//
//  NewsListViewModel.swift
//  NyTimes
//
//  Created by APPLE on 30/04/20.
//  Copyright © 2020 Isha Ramdasi. All rights reserved.
//

import Foundation

/*
The ViewModel contains presentation logic for preparing data to be shown by the View (e.g. providing a localized groups category string). Any interactions it gets forwarded from the View are delegated to the Interactor or Coordinator, depending on the kind of interaction.
*/
final class MostVisitedNewsListViewModel {
    
    private let interactor: MostVisitedNewsListInteractorProtocol
    private let coordinator: MostVisitedNewsListCoordinatorProtocol
    
    private var newsList: [NewsList] {
        return interactor.newsList
    }
    
    init(interactor: MostVisitedNewsListInteractorProtocol, coordinator: MostVisitedNewsListCoordinatorProtocol) {
        self.interactor = interactor
        self.coordinator = coordinator
    }
    
    /*
     Create data model for a particular news on the row
     */
    func data(forRowAt index: Int) -> NewsDataModel {
        let news = newsList[index]
        return NewsDataModel(id: news.id , title: news.title ?? "", abstract: news.abstract ?? "", imgLink: news.imgLink ?? "", url: news.url ?? "")
    }
    
    /*
    Show details of particular news
    */
    func showGroup(at index: Int) {
        coordinator.present(newsList: newsList[index])
    }
    
    /*
    Get nmber of news count
    */
    func numberOfRows() -> Int {
        return newsList.count
    }
    
    /*
    Fetch news from interactor
    */
    func fetchNews(completionHandler: @escaping (Any?, String?) -> Void){
        interactor.fetchNews { (data, error) in
            completionHandler(data, error)
        }
    }
}
