//
//  NewsDetailsViewModel.swift
//  NyNews
//
//  Created by APPLE on 06/05/20.
//  Copyright © 2020 Isha Ramdasi. All rights reserved.
//

import Foundation

/*
 The ViewModel contains presentation logic for preparing data to be shown by the View (e.g. providing a localized groups category string). Any interactions it gets forwarded from the View are delegated to the Interactor or Coordinator, depending on the kind of interaction.
 */
final class NewsDetailsViewModel {
    
    private let interactor: NewsDetailsInteractorProtocol
    private let coordinator: NewsDetailsCoordinatorProtocol
    
    private var newsDetails: NewsList {
        return interactor.newsDetails
    }
    
    init(interactor: NewsDetailsInteractorProtocol, coordinator: NewsDetailsCoordinatorProtocol) {
        self.interactor = interactor
        self.coordinator = coordinator
    }
    
    /*
     Get details of news
     */
    func getNewsDetails() -> NewsList{
        return self.newsDetails
    }
    
    /*
     Set a particular news as favourite or unfavourite
     */
    func handleFavouriteButtonAction(choice: Bool) {
        NewsCoreDataManager.sharedInstance.setNewsFavouriteOrUnfavourite(choice: choice, id: self.newsDetails.id)
    }
}
