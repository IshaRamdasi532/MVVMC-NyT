//
//  ViewController.swift
//  NyNews
//
//  Created by APPLE on 01/05/20.
//  Copyright © 2020 Isha Ramdasi. All rights reserved.
//

import UIKit
import Toast_Swift

enum TitleTab: Int {
    case news = 0
    case videos = 1
    case sports = 2
    case favourites = 3
}

class ViewController: UIViewController {
    
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var comingSoonLbl: UILabel!
    @IBOutlet weak var mostVisitedBtn: UIButton!
    
    @IBOutlet weak var favouritesTableView: UITableView!
    @IBOutlet weak var facebookBtn: UIButton!
    
    @IBOutlet weak var optionsCollectionView: UICollectionView!
    @IBOutlet weak var emailBtn: UIButton!
    
    let newsListCoordinator = NewsListCoordinator()
    let newsListInteractor = NewsListInteractor()
    var newsListViewModel: NewsListViewModel?
    let network: NetworkManager = NetworkManager.sharedInstance
    var newsList: [NewsList] = []
    var selectedOption = 0
    
    //MARK - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //initialize view model
        newsListCoordinator.navigationController = self.navigationController
        newsListViewModel = NewsListViewModel(interactor: newsListInteractor, coordinator: newsListCoordinator)
        
        //register collection view cell and table view cell
        let nib = UINib(nibName: "NewsOptionsCollectionViewCell", bundle: nil)
               optionsCollectionView.register(nib, forCellWithReuseIdentifier: "NewsOptionsCollectionViewCell")
               optionsCollectionView.dataSource = self
               optionsCollectionView.delegate = self
        
        let tableNib = UINib(nibName:"MostVisitedNewsTableViewCell", bundle: nil)
        favouritesTableView.register(tableNib, forCellReuseIdentifier: "MostVisitedNewsTableViewCell")
        favouritesTableView.dataSource = self
        favouritesTableView.delegate = self
        favouritesTableView.tableFooterView = UIView()
        
        //fetch latest data
        if (NetworkManager.sharedInstance.reachability).connection != .unavailable {
           fetchData()
        } else {
            //show from db
            DispatchQueue.main.async {
                //take contol back on main thread
                self.newsList = NewsCoreDataManager.sharedInstance.fetchAllNews()
            }
        }
    }
    
    /*
     Fetch all the latest news data
     */
    func fetchData() {
        
        newsListViewModel?.getVisitedNews(completionHandler: { (data, error) in
            if error != nil {
                if NewsCoreDataManager.sharedInstance.fetchAllNews().count > 0 {
                    self.newsList = NewsCoreDataManager.sharedInstance.fetchAllNews()
                }
                DispatchQueue.main.async {
                    self.view.makeToast(error!)
                }
            }
        })
    }

    /*
     Show most visited news list
     */
    @IBAction func getMostViewedNews(_ sender: UIButton) {
        newsListViewModel?.showMostVisitedList(list: newsList)
    }
    
    
}

 //MARK - Collection View Data source and delegate

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsListViewModel?.getNumberOfSections() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsOptionsCollectionViewCell", for: indexPath) as? NewsOptionsCollectionViewCell else {
            return UICollectionViewCell()
        }

        let data = newsListViewModel?.getData(row: indexPath.row)
        cell.titleLbl.text = data ?? ""
        cell.titleLbl.backgroundColor = selectedOption == indexPath.item ? UIColor(red: 31/255, green: 33/255, blue: 36/255, alpha: 0.8) : UIColor(red: 31/255, green: 33/255, blue: 36/255, alpha: 1.0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width)/CGFloat(newsListViewModel?.getNumberOfSections() ?? 1)), height: 64.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedOption = indexPath.item
        switch indexPath.item {
        case TitleTab.news.rawValue:
            baseView.isHidden = false
            comingSoonLbl.isHidden = true
            favouritesTableView.isHidden = true
            break
        case TitleTab.sports.rawValue, TitleTab.videos.rawValue:
            baseView.isHidden = true
            comingSoonLbl.isHidden = false
            favouritesTableView.isHidden = true
            break
        case TitleTab.favourites.rawValue:
            baseView.isHidden = true
            comingSoonLbl.isHidden = true
            favouritesTableView.isHidden = false
            favouritesTableView.reloadData()
            break
        default:
            break
        }
        collectionView.reloadData()
    }
}

 //MARK - Table View datasource and delegate
 
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsListViewModel?.getNumberOfFavouriteNews().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = favouritesTableView.dequeueReusableCell(withIdentifier: "MostVisitedNewsTableViewCell", for: indexPath) as? MostVisitedNewsTableViewCell else {
            return UITableViewCell()
        }

        let cellViewModel = newsListViewModel?.data(forRowAt: indexPath.row)
        cell.configure(viewModel: cellViewModel!)

        return cell
    }
    
    
}
