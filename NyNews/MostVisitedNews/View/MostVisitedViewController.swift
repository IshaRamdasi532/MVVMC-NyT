//
//  MostVisitedViewController.swift
//  NyNews
//
//  Created by APPLE on 03/05/20.
//  Copyright © 2020 Isha Ramdasi. All rights reserved.
//

import UIKit

class MostVisitedViewController: UIViewController {

    @IBOutlet weak var tableVw: UITableView!
    private let refreshControl = UIRefreshControl()

    var viewModel : MostVisitedNewsListViewModel {
        didSet {
            self.updateUI()
        }
    }
    
    //MARK - View Controller life cycle
    init(viewModel: MostVisitedNewsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        viewModel.fetchNews { (data, error) in
            self.updateUI()
        }
    }

    //MARK - Helper methods
    /*
     Configure UI
     */
    private func setUp() {
        tableVw.delegate = self
        tableVw.dataSource = self
        let nib = UINib(nibName: "MostVisitedNewsTableViewCell", bundle: nil)
        tableVw.register(nib, forCellReuseIdentifier: "MostVisitedNewsTableViewCell")
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableVw.refreshControl = refreshControl
        } else {
            tableVw.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshNewsData(_:)), for: .valueChanged)
    }
    
    /*
     Reload table data when new data is updated
     */
    private func updateUI() {
        DispatchQueue.main.async {
            self.tableVw.reloadData()
        }
    }
    
    /*
    Reload table data when pull to refresh is done
    */
    @objc private func refreshNewsData(_ sender: Any) {
        // Fetch News Data
        viewModel.fetchNews { (data, error) in
            DispatchQueue.main.async {
                self.updateUI()
                self.refreshControl.endRefreshing()
            }
        }
    }

}

//MARK - Table view datasource and delegate
extension MostVisitedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel.numberOfRows())
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableVw.dequeueReusableCell(withIdentifier: "MostVisitedNewsTableViewCell", for: indexPath) as? MostVisitedNewsTableViewCell else {
            return UITableViewCell()
        }

        let cellViewModel = viewModel.data(forRowAt: indexPath.row)
        cell.configure(viewModel: cellViewModel)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.showGroup(at: indexPath.row)
    }
}

