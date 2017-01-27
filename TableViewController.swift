//
//  TableViewController.swift
//  Good GO
//
//  Created by QUANG on 1/27/17.
//  Copyright © 2017 Start Swift. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import SwiftyJSON
import CircularSlider

class TableViewController: UITableViewController, CLLocationManagerDelegate {
    
    //MARK: Properties:
    let locationManager = CLLocationManager() //For location detection
    var userCity: String = ""
    var weatherData = [WeatherData]()
    
    var city: String = ""
    var country: String = ""
    var region: String = ""
    
    var humidity: Int = 0

    var sunrise = Date()
    var sunset = Date()
    
    var pubDate = Date()
    
    var temp: Int = 0
    var text: String = ""
    
    var tempHighToday: Int = 58
    var tempLowToday: Int = 0
    var textToday: String = ""

    //MARK: Outlets
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblCountry: UILabel!
    @IBOutlet var lblRegion: UILabel!
    
    @IBOutlet var lblPubDate: UILabel!
    @IBOutlet var lblText: UILabel!
    @IBOutlet var lblWillRain: UILabel!
    @IBOutlet var lblSunrise: UILabel!
    @IBOutlet var lblSunset: UILabel!
    
    @IBOutlet var humidSlider: CircularSlider!
    @IBOutlet var tempSlider: CircularSlider!
    
    //MARK: Defaults
    override func viewDidLoad() {
        super.viewDidLoad()

        getUserCity()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //MARK: Private Methods
    func setupNotificationSettings() {
        //For notification
        UNUserNotificationCenter.current().delegate = self
        
    }
    
    func getUserCity() {
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    //Tuan complete this ok? Using JSON
    func getDataFrom(city: String) {
        let query = URL(string: getQueryLink(city: city))
        print(query!)
        
        let task = URLSession.shared.dataTask(with: query!) { (data, response, error) in
            if error == nil {
                if let content = data {
                    let json = JSON(data: content)
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "h:mm aa"
                    /////////////////////////////////////////////////////////////
                    
                    //TUAN START HERE
                    //Init data got to weatherData (override index weatherData[0]
                    //Remember using SwiftyJSON
                    if let a = json["query"]["results"]["channel"]["location"]["city"].string {
                        self.city = a
                    }
                    if let country = json["query"]["results"]["channel"]["location"]["country"].string {
                        self.country = country
                    }
                    if let region = json["query"]["results"]["channel"]["location"]["region"].string {
                        self.region = region
                    }
                    /////////////////////////////////////////////////////////////
                    if let humidity = json["query"]["results"]["channel"]["atmosphere"]["humidity"].string {
                        self.humidity = Int(humidity)!
                    }
                    /////////////////////////////////////////////////////////////
                    if let sunrise = json["query"]["results"]["channel"]["astronomy"]["sunrise"].string {
                        let date = dateFormatter.date(from: sunrise)
                        self.sunrise = date!
                    }
                    if let sunset = json["query"]["results"]["channel"]["astronomy"]["sunset"].string {
                        let date = dateFormatter.date(from: sunset)
                        self.sunset = date!
                    }
                    /////////////////////////////////////////////////////////////
                    if let pubDate = json["query"]["results"]["channel"]["item"]["pubDate"].string {
                        let uniqueFormatter = DateFormatter()
                        uniqueFormatter.dateFormat = "E, d MMM yyyy hh:mm aa zzzz"
                        
                        let date = uniqueFormatter.date(from: pubDate.replacingOccurrences(of: "ICT", with: "Indochina Time"))
                        self.pubDate = date!
                    }
                    /////////////////////////////////////////////////////////////
                    if let temp = json["query"]["results"]["channel"]["item"]["condition"]["temp"].string {
                        self.temp = self.convertToCelsius(fahrenheit: Int(temp)!)
                    }
                    if let text = json["query"]["results"]["channel"]["item"]["condition"]["text"].string {
                        self.text = text
                    }
                    /////////////////////////////////////////////////////////////
                    if let tempHighToday = json["query"]["results"]["channel"]["item"]["forecast"][0]["high"].string {
                        self.tempHighToday = self.convertToCelsius(fahrenheit: Int(tempHighToday)!)
                    }
                    if let tempLowToday = json["query"]["results"]["channel"]["item"]["forecast"][0]["low"].string {
                        self.tempLowToday = self.convertToCelsius(fahrenheit: Int(tempLowToday)!)
                    }
                    if let textToday = json["query"]["results"]["channel"]["item"]["forecast"][0]["text"].string {
                        self.textToday = textToday
                    }
                    self.initialize()
                    /////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////
                    if !self.weatherData.isEmpty {
                        self.saveData()
                    }
                    
                    self.updateUI()
                }
            }
            else {
                print("Somthing went wrong")
            }
        }
        task.resume()
    }
    
    func getQueryLink(city: String) -> String {
        let statement = "select * from weather.forecast where woeid in (select woeid from geo.places(1) where text='\(city), vn')"
        let query_prefix = "https://query.yahooapis.com/v1/public/yql?q="
        let query_suffix = "&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
        
        let query = "\(query_prefix)\(statement.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)\(query_suffix)"
        
        //print(query)
        return query
    }
    
    private func loadData() -> [WeatherData]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: WeatherData.ArchiveURL.path) as? [WeatherData]
    }
    
    private func loadSavedData(){
        if let savedData = loadData() {
            weatherData.removeAll()
            weatherData += savedData
        }
        else {
            print("No data to load")
        }
    }
    
    private func saveData() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(weatherData, toFile: WeatherData.ArchiveURL.path)
        if isSuccessfulSave {
            print("Successfully saved.")
        } else {
            print("Failed to save...")
        }
    }
    
    func convertToCelsius(fahrenheit: Int) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }
    
    func initialize() {
        weatherData.removeAll()
        weatherData.append(WeatherData(city: city,
                                       country: country,
                                       region: region,
                                       humidity: humidity,
                                       sunrise: sunrise,
                                       sunset: sunset,
                                       pubDate: pubDate,
                                       temp: temp,
                                       text: text,
                                       tempHighToday: tempHighToday,
                                       tempLowToday: tempLowToday,
                                       textToday: textToday)!)
    }
    
    func updateUI() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        if let data = weatherData[safe: 0] {
            DispatchQueue.main.async {
                self.lblCity.text = "Thành phố: \(data.city!)"
                self.lblCountry.text = "Quốc gia: \(data.country!)"
                self.lblRegion.text = "Vùng: \(data.region!)"
                
                self.lblPubDate.text = "Cập nhật cuối: \(dateFormatter.string(from: data.pubDate!))"
                self.lblText.text = "Hiện tại: \(data.text!)"
                
                print(data.textToday ?? "No value")
                if data.textToday?.lowercased() == "rain" || data.textToday?.lowercased() == "showers" {
                    self.lblWillRain.text = "Có mưa: Có"
                }
                else {
                    self.lblWillRain.text = "Có mưa: Không"
                }
                
                self.lblSunrise.text = "Bình minh: \(dateFormatter.string(from: data.sunrise!)[9...13]) am"
                self.lblSunset.text = "Hoàng hôn: \(dateFormatter.string(from: data.sunset!)[9...13]) pm"
                
                self.humidSlider.setValue(Float(data.humidity!), animated: true)
                
                if data.tempHighToday! != 0 {
                    self.tempSlider.maximumValue = Float(data.tempHighToday!)
                }
                if data.tempLowToday! != 0 {
                    self.tempSlider.minimumValue = Float(data.tempLowToday!)
                }
                print(data.temp!)
                if data.temp! != 0 {
                    self.tempSlider.setValue(Float(data.temp!), animated: true)
                }
            }
        }
        else {
            print("No data")
        }
    }
    
    //MARK: Location Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Get latitude and longitude
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        locationManager.stopUpdatingLocation()
        
        //Convert from latitude and longitude to city
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            if error == nil {
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
                // City
                if let city = placeMark.addressDictionary!["City"] as? NSString {
                    self.userCity = city as String
                    print(self.userCity)
                    self.getDataFrom(city: self.userCity)
                }
            }
            else {
                print("Something happened")
            }
            
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UITableViewController: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //Some other way of handing notification in app
        completionHandler([.alert, .sound])
    }
}

