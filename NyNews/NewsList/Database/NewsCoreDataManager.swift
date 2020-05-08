//
//  NewsCoreDataManager.swift
//  NyTimes
//
//  Created by APPLE on 30/04/20.
//  Copyright © 2020 Isha Ramdasi. All rights reserved.
//

import Foundation
import CoreData

class NewsCoreDataManager: NSObject {
    static let sharedInstance = NewsCoreDataManager()
    dynamic var allNews:[NewsList] = [NewsList]()
    
    override private init () {
        
    }
    /*
    Saving data recieved from API
    */
    func savingDataToDBInPrivateQueueContext(jsonDictionary:Any) {
            
            DatabaseManager.sharedInstance.persistentContainer.performBackgroundTask({ (context) in
                autoreleasepool {
                   NewsList.getNewsObjFromDictionary(managedObjectContext: context, json: jsonDictionary)
                }
            })
    }
    
    /*
     Fetch all news from database
     */
    func fetchAllNews() -> [NewsList]{
        let fetchRequest: NSFetchRequest<NewsList> = NSFetchRequest(entityName: "NewsList")
        do{
            self.allNews.append(contentsOf: try DatabaseManager.sharedInstance.mainQueueContext.fetch(fetchRequest))
            return self.allNews
        }
        catch {
            print(error)
        }
        return []
    }
    
    /*
    Check if news with particular id is present in the database
    */
    func fetchIfNewsWithIDExists(id: Int64) -> Bool {
        let fetchRequest: NSFetchRequest<NewsList> = NSFetchRequest(entityName: "NewsList")
        let predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
        fetchRequest.predicate = predicate
        do{
            let obj = try DatabaseManager.sharedInstance.mainQueueContext.fetch(fetchRequest)
            if obj.count > 0 {
                return true
            }
        } catch {
            
        }
        return false
    }
    
    /*
    Mark news as favourite
    */
    func setNewsFavouriteOrUnfavourite(choice: Bool, id: Int64) {
        let fetchRequest: NSFetchRequest<NewsList> = NSFetchRequest(entityName: "NewsList")
        let predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
        fetchRequest.predicate = predicate
        do{
            let obj = try DatabaseManager.sharedInstance.mainQueueContext.fetch(fetchRequest)
            if obj.count > 0 {
                DatabaseManager.sharedInstance.persistentContainer.performBackgroundTask({ (context) in
                    autoreleasepool {
                        obj.first?.favourite = choice
                        if context.hasChanges {
                            do {
                                try context.save()
                            } catch {
                                
                            }
                        }
                        context.reset()
                    }
                })
            }
        } catch {
            
        }
    }
    
    /*
    Fetch favourite news
    */
    func fetchFavouriteNews() -> [NewsList]{
        let fetchRequest: NSFetchRequest<NewsList> = NSFetchRequest(entityName: "NewsList")
        let predicate = NSPredicate(format: "favourite == true")
        fetchRequest.predicate = predicate
        do{
            let news = try DatabaseManager.sharedInstance.mainQueueContext.fetch(fetchRequest)
            return news
        }
        catch {
            print(error)
        }
        return []
    }
}


