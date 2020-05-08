//
//  NewsDetailsCoordinator.swift
//  NyNews
//
//  Created by APPLE on 06/05/20.
//  Copyright © 2020 Isha Ramdasi. All rights reserved.
//

import Foundation
import UIKit

protocol NewsDetailsCoordinatorProtocol: class {
    func present(newsList: NewsList)
    func dismissGroup()
}

/*
 Coordinator is responsible for navigation. Next screen presentation and current screen dismissal is taken care by coordinator
 */
final class NewsDetailsCoordinator: NewsDetailsCoordinatorProtocol {
    
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
           self.navigationController = navigationController
    }
    
    /*
     Show next screen
     */
    func present(newsList: NewsList) {
    }
    
    func dismissGroup() {
        navigationController?.popViewController(animated: true)
    }
}
