//
//  Yahoo API.swift
//  Good GO
//
//  Created by QUANG on 1/27/17.
//  Copyright © 2017 Start Swift. All rights reserved.
//
import UIKit

class YahooAPI {    
    func getQueryLink(city: String) -> String {
        let statement = "select * from weather.forecast where woeid in (select woeid from geo.places(1) where text='\(city), vn')"
        let query_prefix = "https://query.yahooapis.com/v1/public/yql?q="
        let query_suffix = "&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
        
        let query = "\(query_prefix)\(statement.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))\(query_suffix)"
        
        print(query)
        return query
    }
}
