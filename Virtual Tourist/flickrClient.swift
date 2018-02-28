//
//  flickrClient.swift
//  Virtual Tourist
//
//  Created by Feras Allaou on 2/22/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.

import Foundation


class FlickrClient{
    
    let getPhotosURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search"
    
    func prepareParameters(params: [String: AnyObject]) -> String {
        var parametes = params
        var extraParameters = ""
        parametes["api_key"] = "ebda1d5af7e68e6adc4b224f820e3847" as AnyObject
        parametes["per_page"] = 15 as AnyObject
        parametes["format"] = "json" as AnyObject
        parametes["extras"] = "url_s" as AnyObject
        parametes["nojsoncallback"] = 1 as AnyObject
        var paramsArr = [String]()
            for (key, value) in parametes{
                let tempString = key + "=\(value)"
                paramsArr.append(tempString)
            }
             extraParameters = paramsArr.joined(separator: "&")
        
     return getPhotosURL + "&" + extraParameters
    }
    
    func makeGetRequest(url: String, getRequestCompltionHandler: @escaping ( [String: AnyObject]? , String? ) -> Void ) {
        let mUrl = URL(string: url)
        let request = URLRequest(url: mUrl!)
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            
            guard error == nil else {
                getRequestCompltionHandler(nil, " \(String(describing: error!.localizedDescription))")
                return
            }
            
            
            guard let data = data else{
                getRequestCompltionHandler(nil, "Error in Getting photos.")
                return
            }
            
            
            var flickrResponse = [String: AnyObject]()
                do {
                    flickrResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                }catch{
                getRequestCompltionHandler(nil, "Couldn't Parse Data")
                return
                }
            
            guard let status = flickrResponse["stat"] as? String, status.lowercased() == "ok" else {
                getRequestCompltionHandler(nil, "Request Stats was not OK")
                return
            }
            
            guard let photosDictionary = flickrResponse["photos"] as? [String: AnyObject] else{
                getRequestCompltionHandler(nil, "Please try again.")
                return
            }
            
            
            getRequestCompltionHandler(photosDictionary, nil)
         }
        task.resume()
    }
    
    func getPhotos(url: String, getPhotosCompletionHandler:  @escaping ([AnyObject]?, String?) -> Void ) {
        
        makeGetRequest(url: url) {
            (response, error) in
            
            guard error == nil else {
                getPhotosCompletionHandler(nil, "Got an error \(error!.debugDescription)")
                return
            }
            
            if let response = response {
                let totalPages = response["pages"] as? Int ?? 1
                var randomPageNumber = Int(arc4random_uniform(265) + 1)
                
                while randomPageNumber > totalPages {
                    randomPageNumber = Int(arc4random_uniform(265) + 1)
                }
                
                if randomPageNumber == 1 {
                    
                    guard let photoObject = response["photo"] as? [AnyObject] else {
                        getPhotosCompletionHandler(nil, "There are No Photos!")
                        return
                    }
                    
                    getPhotosCompletionHandler(photoObject, nil)
                    
                }else{
                   let newUrl = url + "&page=\(randomPageNumber)"
                    self.makeGetRequest(url: newUrl) {
                        (newResponse, newError) in
                        
                        guard error == nil else {
                            getPhotosCompletionHandler(nil, "Got an error \(error!.debugDescription)")
                            return
                        }
                        
                        guard let photoObject = newResponse!["photo"] as? [AnyObject] else {
                            getPhotosCompletionHandler(nil, "There are No Photos!")
                            return
                        }
                        
                        getPhotosCompletionHandler(photoObject, nil)
                        
                        
                    }
                }
            }
            
            
         }
        
    }
    
    
}
