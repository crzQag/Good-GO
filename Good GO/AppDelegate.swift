//
//  AppDelegate.swift
//  Good GO
//
//  Created by QUANG on 1/27/17.
//  Copyright © 2017 Start Swift. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: Properties
    var weatherData = [WeatherData]()
    
    struct state {
        static let rain = "rain"
        static let tornado = "tornado"
        static let tropicalStorm = "tropicalStorm"
        static let hurricane = "hurricane"
        static let severeThunderstorms = "severeThunderstorms"
        static let thunderstorms = "thunderstorms"
        static let cold = "cold"
        static let hot = "hot"
        static let showers = "showers"
    }

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Fetch background
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: Date())
        let minutes = calendar.component(.minute, from: Date())
        let interval = (((12 - (hour % 12)) + 7) * 3600) - (60 * minutes)
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(interval))
        
        //Notification
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: { (accepted, error) in
            if !accepted {
                print("Notification access denied.")
            }
        }
        )
        
        let responseThanks = UNNotificationAction(identifier: "responseThanks", title: "Cảm ơn nha!", options: [.foreground])
        let responseCategory = UNNotificationCategory(identifier: "responseCategory", actions: [responseThanks], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([responseCategory])
        
        return true
    }
    
    // Support for background fetch
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        //Get data (After Tuan done his part)
        
        
        /////////////////////////////////////
        if let data = weatherData[safe: 0] {
            if data.textToday == state.showers || data.textToday == state.rain {
                notifyRain()
            }
        }
        else {
            print("Error")
        }
    }
    
    //MARK: Private Methods
    func notifyRain() {
        let contentStart = UNMutableNotificationContent()
        contentStart.title = "Good GO"
        contentStart.subtitle = "ĐỢI 1 CHÚT"
        contentStart.body = "Hôm nay sẽ có mưa, hãy mang theo áo mưa hay ô nha!"
        contentStart.sound = UNNotificationSound.default()
        
        let notifyDate = Date(timeIntervalSinceNow: 1)
        let triggerDate = Calendar.current.dateComponents([.hour,.minute,.second,], from: notifyDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let requestIdentifier = "rainNoti"
        
        let request = UNNotificationRequest(identifier: requestIdentifier, content: contentStart, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if let _ = error {
                print("Error")
            }
        })
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

