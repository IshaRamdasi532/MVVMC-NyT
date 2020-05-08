//
//  MostVisitedNewsTableViewCell.swift
//  NyNews
//
//  Created by APPLE on 02/05/20.
//  Copyright © 2020 Isha Ramdasi. All rights reserved.
//

import UIKit

struct NewsDataModel {
    let id: Int64
    let title: String
    let abstract: String
    let imgLink: String
    let url: String
}

class MostVisitedNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImg: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsAbstract: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*
     Configure most visited news cell which displays all the details of the news
     */
    func configure(viewModel: NewsDataModel) {
        newsTitle.text = viewModel.title
        newsAbstract.text = viewModel.abstract
        if let url = URL(string: viewModel.imgLink) {
            if (NetworkManager.sharedInstance.reachability).connection != .unavailable {
                guard let data = try? Data(contentsOf: url) else {
                    print("No image found")
                    return
                }
                newsImg.image = UIImage(data: data)
            }
        }
    }

    
}
