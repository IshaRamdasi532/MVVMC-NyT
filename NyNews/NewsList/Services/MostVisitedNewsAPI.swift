//
//  MostVisitedNewsAPI.swift
//  NyTimes
//
//  Created by APPLE on 30/04/20.
//  Copyright © 2020 Isha Ramdasi. All rights reserved.
//

import Foundation

class MostVisitedNewsAPI: NSObject {
    static let service = MostVisitedNewsAPI()
    
    /*
     Get most visited news from website
     */
    func getListOfMostVisitedNews(completionHandler:@escaping (Any?, String?) -> Void) {
        
        let session = URLSession(configuration: .default)
        
        let url = URL(string: "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json?api-key=J9okO1yZ806IsjHr3JPWqw2QWjE0LodI")!
        
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField:"Accept")
        
        let task = session.dataTask(with: url) { data, response, error in
            if response == nil {
                if error != nil || data == nil {
                    print("Client error!")
                    completionHandler(nil, error?.localizedDescription)
                    return
                }
                
                if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
                    if let mime = response.mimeType, mime == "application/json" {
                        completionHandler(nil, "Something went wrong")
                        return
                    } else {
                        print("Wrong MIME type!")
                        completionHandler(nil, error?.localizedDescription)
                        return
                    }
                } else {
                    print("Server error!")
                    completionHandler(nil, "Server error")
                    return
                }
            } else {
                
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    print(json)
                    NewsCoreDataManager.sharedInstance.savingDataToDBInPrivateQueueContext(jsonDictionary: json)
                    completionHandler(json, nil)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                    completionHandler(nil, error.localizedDescription)
                    return
                }
            }
        }
        
        task.resume()
    }
    
}

