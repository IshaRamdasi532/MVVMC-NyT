//
//  NewsListCoordinator.swift
//  NyTimes
//
//  Created by APPLE on 30/04/20.
//  Copyright © 2020 Isha Ramdasi. All rights reserved.
//

import Foundation
import UIKit

protocol MostVisitedNewsListCoordinatorProtocol: class {
    func present(newsList: NewsList)
    func dismissGroup()
}

/*
Coordinator is responsible for navigation. Next screen presentation and current screen dismissal is taken care by coordinator
*/
final class MostVisitedNewsListCoordinator: MostVisitedNewsListCoordinatorProtocol {
    
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
           self.navigationController = navigationController
    }
    
    func present(newsList: NewsList) {
        
        // Preparing the new calçot
        let newsCoordinator = NewsDetailsCoordinator(navigationController: navigationController!)
        let newsInteractor = NewsDetailsInteractor(news: newsList)
        let newsDetailsViewModel = NewsDetailsViewModel(interactor: newsInteractor, coordinator: newsCoordinator)
        let newsDetailsViewController = NewsDetailsViewController(viewModel: newsDetailsViewModel)

        // Adding observer listening to group members change
        newsInteractor.newsDidChange.add { [weak newsDetailsViewController, weak newsInteractor] in
            guard let interactor = newsInteractor else { return }
            newsDetailsViewController?.viewModel = NewsDetailsViewModel(interactor: interactor, coordinator: newsCoordinator)
        }

        // Navigate to the new screen
        navigationController?.pushViewController(newsDetailsViewController, animated: true)
    }
    
    func dismissGroup() {
        navigationController?.popViewController(animated: true)
    }
}
