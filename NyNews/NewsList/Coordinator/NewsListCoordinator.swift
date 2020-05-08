//
//  NewsListCoordinator.swift
//  NyTimes
//
//  Created by APPLE on 30/04/20.
//  Copyright © 2020 Isha Ramdasi. All rights reserved.
//

import Foundation
import UIKit

protocol NewsListCoordinatorProtocol: class {
    func present(newsList:[NewsList])
    func dismissGroup()
}

/*
Coordinator is responsible for navigation. Next screen presentation and current screen dismissal is taken care by coordinator
*/
final class NewsListCoordinator: NewsListCoordinatorProtocol {
    
    weak var navigationController: UINavigationController?
    
    func present(newsList:[NewsList]) {
        
        // Preparing the new calçot
        let newsListCoordinator = MostVisitedNewsListCoordinator(navigationController: self.navigationController!)
        let newsListInteractor = MostVisitedNewsListInteractor(news: newsList)
        let newsListViewModel = MostVisitedNewsListViewModel(interactor: newsListInteractor, coordinator: newsListCoordinator)
        let newsListViewController = MostVisitedViewController(viewModel: newsListViewModel)
       // newsListViewController.viewModel = newsListViewModel
        // Adding observer listening to group members change
        newsListInteractor.newsDidChange.add { [weak newsListViewController, weak newsListInteractor] in
            guard let interactor = newsListInteractor else { return }
            newsListViewController?.viewModel = MostVisitedNewsListViewModel(interactor: interactor, coordinator: newsListCoordinator)
        }

        // Navigate to the new screen
        navigationController?.pushViewController(newsListViewController, animated: true)
    }
    
    func dismissGroup() {
        navigationController?.popViewController(animated: true)
    }
}
