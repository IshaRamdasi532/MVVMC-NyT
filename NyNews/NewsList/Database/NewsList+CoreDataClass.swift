//
//  NewsList+CoreDataClass.swift
//  NyTimes
//
//  Created by APPLE on 30/04/20.
//  Copyright © 2020 Isha Ramdasi. All rights reserved.
//
//

import Foundation
import CoreData

@objc(NewsList)

public class NewsList: NSManagedObject {

    public static func getNewsObjFromDictionary(managedObjectContext:NSManagedObjectContext,json:Any) {
        guard let mainDict = json as? [String: Any] else {
            return 
        }
        guard let results = mainDict["results"] as? [Any] else {
            print("Data not parsed")
            return
        }
        for i in 0..<results.count {
            guard let dict = results[i] as? [String: Any] else {
                return
            }
            
            guard let id = dict["id"] as? Int64, let title = dict["title"] as? String, let abstract = dict["abstract"] as? String, let url = dict["url"] as? String else {
                return
            }
            if !NewsCoreDataManager.sharedInstance.fetchIfNewsWithIDExists(id: id) {
                let news = NewsList(context: managedObjectContext)
                news.id = id
                news.title = title
                news.abstract = abstract
                news.url = url
                news.imgLink = ""
                news.favourite = false
                if let media = dict["media"] as? [[String:Any]], media.count > 0, let metadata = (media.first)!["media-metadata"] as? [[String: Any]], let img = ((metadata.first)!)["url"] as? String {
                        news.imgLink = img
                }
                
                if managedObjectContext.hasChanges {
                    do {
                        try managedObjectContext.save()
                    } catch {
                        print("Coredata saving error")
                    }
                }
                managedObjectContext.reset()
            }
        }
    }
}
