//
//  flickrClient.swift
//  Virtual Tourist
//
//  Created by Feras Allaou on 2/22/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation


class FlickrClient{
    
    let getPhotosURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search"
    
    func prepareParameters(params: [String: AnyObject]) -> String {
        var parametes = params
        var extraParameters = ""
        parametes["api_key"] = "ebda1d5af7e68e6adc4b224f820e3847" as AnyObject
        parametes["per_page"] = 15 as AnyObject
        parametes["format"] = "json" as AnyObject
        parametes["extras"] = "url_m" as AnyObject
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
                getRequestCompltionHandler(nil, "Got an Error \(String(describing: error?.localizedDescription))")
                return
            }
            var flickrResponse = [String: AnyObject]()
            if let data = data {
                do {

                    flickrResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                }catch{
                getRequestCompltionHandler(nil, "Couldn't get Data1")
                return
                }
            }else{
                getRequestCompltionHandler(nil, "Couldn't get Data!")
                return
            }
            getRequestCompltionHandler(flickrResponse, nil)
         }
        task.resume()
    }
    
    
    
    
}
