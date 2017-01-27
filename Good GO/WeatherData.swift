//
//  WeatherData.swift
//  Good GO
//
//  Created by QUANG on 1/27/17.
//  Copyright © 2017 Start Swift. All rights reserved.
//

import UIKit

class WeatherData: NSObject, NSCoding {
    
    /*
    
    distance : mi
    
    pressure : in
    
    speed : mph
    
    temperature : F
*/
    
    //MARK: Types
    struct PropertyKey {
        //Location
        static let city = "city" //String
        static let country = "country" //String
        static let region = "region" //String
        
        /*
        //Wind
        static let chill = "chill" //Int (%)
        static let direction = "direction" //Int
        static let speed = "speed" //Int
        */
        
        //Atmosphere
        static let humidity = "humidity " //(%)
        //static let pressure = "pressure" //Float
        //static let rising = "rising" //Int
        //static let visibility = "visibility" //Float
        
        //Astronomy
        static let sunrise = "sunrise" //Date
        static let sunset = "sunset" //Date
        
        //Item
        //static let title = "title " //String
        //static let link = "link" //String
        static let pubDate = "pubDate" //Date
        
        //Condition
        static let temp = "temp " //Int
        static let text = "text" //String
        
        //Today (index 0 of forecast)
        static let tempHighToday = "nextTempHigh" //Int
        static let tempLowToday = "nextTempLow" //Int
        static let textToday = "nextText" //String
    }
    
    //MARK: Properties (All are optional)
    var city: String?
    var country: String?
    var region: String?
    
    //var chill: Int?
    //var direction: Int? //7 digits
    //var speed: Int?
    
    var humidity: Int?
    //var pressure: Float?
    //var rising: Int? //7 digits
    //var visibility: Float?
    
    var sunrise: Date?
    var sunset: Date?
    
    //var title: String? //7 digits
    //var link: String?
    var pubDate: Date? //7 digits
    
    var temp: Int?
    var text: String?
    
    var tempHighToday: Int?
    var tempLowToday: Int? //7 digits
    var textToday: String?
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("WeatherData")
    
    //MARK: Initialization
    init?(city: String?, country: String?, region: String?/*, chill: Int?, direction: Int?, speed: Int?*/, humidity: Int?/*, pressure: Float?, rising: Int?, visibility: Float?*/, sunrise: Date?, sunset: Date?/*, title: String?, link: String?*/, pubDate: Date?, temp: Int?, text: String?, tempHighToday: Int?, tempLowToday: Int?, textToday: String?) {
        
        //Because everything is optional
        self.city = city
        self.country = country
        self.region = region
        
        //self.chill = chill
        //self.direction = direction
        //self.speed = speed
        
        self.humidity = humidity
        //self.pressure = pressure
        //self.rising = rising
        //self.visibility = visibility
        
        self.sunrise = sunrise
        self.sunset = sunset
        
        //self.title = title
        //self.link = link
        self.pubDate = pubDate
        
        self.temp = temp
        self.text = text
        
        self.tempHighToday = tempHighToday
        self.tempLowToday = tempLowToday
        self.textToday = textToday
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(city, forKey: PropertyKey.city)
        aCoder.encode(country, forKey: PropertyKey.country)
        aCoder.encode(region, forKey: PropertyKey.region)
        
        //aCoder.encode(chill, forKey: PropertyKey.chill)
        //aCoder.encode(direction, forKey: PropertyKey.direction)
        //aCoder.encode(speed, forKey: PropertyKey.speed)
        
        aCoder.encode(humidity, forKey: PropertyKey.humidity)
        //aCoder.encode(pressure, forKey: PropertyKey.pressure)
        //aCoder.encode(rising, forKey: PropertyKey.rising)
        //aCoder.encode(visibility, forKey: PropertyKey.visibility)
        
        aCoder.encode(sunrise, forKey: PropertyKey.sunrise)
        aCoder.encode(sunset, forKey: PropertyKey.sunset)
        
        //aCoder.encode(title, forKey: PropertyKey.title)
        //aCoder.encode(link, forKey: PropertyKey.link)
        aCoder.encode(pubDate, forKey: PropertyKey.pubDate)
        
        aCoder.encode(temp, forKey: PropertyKey.temp)
        aCoder.encode(text, forKey: PropertyKey.text)
        
        aCoder.encode(tempHighToday, forKey: PropertyKey.tempHighToday)
        aCoder.encode(tempLowToday, forKey: PropertyKey.tempLowToday)
        aCoder.encode(textToday, forKey: PropertyKey.textToday)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // Because everything is an optional property of WeatherData, just use conditional cast.
        let city = aDecoder.decodeObject(forKey: PropertyKey.city) as? String
        let country = aDecoder.decodeObject(forKey: PropertyKey.country) as? String
        let region = aDecoder.decodeObject(forKey: PropertyKey.region) as? String
        
        //let chill = aDecoder.decodeInteger(forKey: PropertyKey.chill)
        //let direction = aDecoder.decodeInteger(forKey: PropertyKey.direction)
        //let speed = aDecoder.decodeInteger(forKey: PropertyKey.speed)
        
        let humidity = aDecoder.decodeInteger(forKey: PropertyKey.humidity)
        //let pressure = aDecoder.decodeFloat(forKey: PropertyKey.pressure)
        //let rising = aDecoder.decodeInteger(forKey: PropertyKey.rising)
        //let visibility = aDecoder.decodeFloat(forKey: PropertyKey.visibility)

        let sunrise = aDecoder.decodeObject(forKey: PropertyKey.sunrise) as? Date
        let sunset = aDecoder.decodeObject(forKey: PropertyKey.sunset) as? Date
        
        //let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String
        //let link = aDecoder.decodeObject(forKey: PropertyKey.link) as? String
        let pubDate = aDecoder.decodeObject(forKey: PropertyKey.pubDate) as? Date
        
        let temp = aDecoder.decodeInteger(forKey: PropertyKey.temp)
        let text = aDecoder.decodeObject(forKey: PropertyKey.text) as? String

        let tempHighToday = aDecoder.decodeInteger(forKey: PropertyKey.tempHighToday)
        let tempLowToday = aDecoder.decodeInteger(forKey: PropertyKey.tempLowToday)
        let textToday = aDecoder.decodeObject(forKey: PropertyKey.textToday) as? String
        
        // Must call designated initializer.
        self.init(city: city, country: country, region: region/*, chill: chill, direction: direction, speed: speed*/, humidity: humidity/*, pressure: pressure, rising: rising, visibility: visibility*/, sunrise: sunrise, sunset: sunset/*, title: title, link: link*/, pubDate: pubDate, temp: temp, text: text, tempHighToday: tempHighToday, tempLowToday: tempLowToday, textToday: textToday)
    }
}
