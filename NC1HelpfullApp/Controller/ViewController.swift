//
//  ViewController.swift
//  NC1HelpfullApp
//
//  Created by Eki Rifaldi on 06/03/20.
//  Copyright © 2020 Eki Rifaldi. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController, CalendarAddedDelegate {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var btnAgenda: UIButton! {
        didSet {
            btnAgenda.backgroundColor = UIColor(named: "buttonColor") 
            btnAgenda.layer.cornerRadius = 5
            btnAgenda.layer.shadowColor = UIColor.black.cgColor
            btnAgenda.layer.shadowOpacity = 1
            btnAgenda.layer.shadowOffset = .zero
            btnAgenda.layer.shadowRadius = 10
        }
    }
    
    var agendas: [AgendaModel] = []
    var agenda: AgendaModel? = nil
    
    var calendars: [EKCalendar]?
    var events: [EKEvent]?
    var allEvents: [EKEvent] = []
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        
        loadAgendasData()
        
//        checkCalendarAuthorizationStatus()
        
        weatherManager.delegate = self
        
        weatherManager.fetchWeather(cityName: "Serpong")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAgenda" {
            let destinationVC = segue.destination as! AgendaViewController
            destinationVC.agenda = agenda
        }
    }
    
    func loadAgendasData(){
        agendas.append(AgendaModel(title: "Bridge1", definition: "Bridge 1 adalah ajang sharing session untuk menganali path masing-masing peserta Apple Academy", image: "satu", tempat: "BSD Green Office Park 9", waktu: "02.00 WIB", jenis: "Individu", bentukKegiatan: "Kelas Besar"))
        
        agendas.append(AgendaModel(title: "Mini Challange 1", definition: "Bridge 1 adalah ajang sharing session untuk menganali path masing-masing peserta Apple Academy", image: "satu", tempat: "BSD Green Office Park 9", waktu: "02.00 WIB", jenis: "Individu", bentukKegiatan: "Kelas Besar"))
        
        agendas.append(AgendaModel(title: "NC2", definition: "Bridge 1 adalah ajang sharing session untuk menganali path masing-masing peserta Apple Academy", image: "satu", tempat: "BSD Green Office Park 9", waktu: "02.00 WIB", jenis: "Individu", bentukKegiatan: "Kelas Besar"))
    }
    
    func getAgendaByTitle(titleFilter: String) -> AgendaModel? {
        return agendas.filter({ $0.title == titleFilter }).first
    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            // Things are in line with being able to show the calendars in the table view
            loadCalendars()
        //            refreshTableView()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied: break
            // We need to help them give us permission
            //            needPermissionView.fadeIn()
            
        default: break
        }
    }
    
    func requestAccessToCalendar() {
        EKEventStore().requestAccess(to: .event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    self.loadCalendars()
                })
            } else {
                DispatchQueue.main.async(execute: {
                })
            }
        })
    }
    
    func calendarDidAdd() {
        self.loadCalendars()
    }
    
    func loadCalendars() {
        self.calendars = EKEventStore().calendars(for: EKEntityType.event).sorted() { (cal1, cal2) -> Bool in
            return cal1.title < cal2.title
        }
        loadEvents()
    }
    
    
    func loadEvents() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterStart = DateFormatter()
        let dateFormatterEnd = DateFormatter()
        dateFormatterStart.dateFormat = "yyyy-MM-dd 00:00:00"
        dateFormatterEnd.dateFormat = "yyyy-MM-dd 23:59:59"
        let date = Date()
        let sDate = dateFormatterStart.string(from: date)
        let eDate = dateFormatterEnd.string(from: date)
        
        let startDate = dateFormatter.date(from: sDate)
        let endDate = dateFormatter.date(from: eDate)
        
        if let startDate = startDate, let endDate = endDate {
            let eventStore = EKEventStore()
            
            let eventsPredicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
            
            self.events = eventStore.events(matching: eventsPredicate).sorted {
                (e1: EKEvent, e2: EKEvent) in
                
                return e1.startDate.compare(e2.startDate) == ComparisonResult.orderedAscending
            }
            
            allEvents.append(contentsOf: events!)
            
            
            for event in allEvents {
                print(event.title ?? "No Title", "in", event.calendar.title)
                
                agenda = getAgendaByTitle(titleFilter: event.title ?? "No Title")
                dateLabel.text = getNowDateTime()
            }
        }
    }
    
    
    //    MARK: - notification
    
    // https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/SchedulingandHandlingLocalNotifications.html
    //    func notification(){
    //        let content = UNMutableNotificationContent()
    //        content.title = NSString.localizedUserNotificationString(forKey: "Wake up!", arguments: nil)
    //        content.body = NSString.localizedUserNotificationString(forKey: "Rise and shine! It's morning time!",
    //                                                                arguments: nil)
    //        // Assign the category (and the associated actions).
    //        content.categoryIdentifier = "TIMER_EXPIRED"
    //        content.sound = UNNotificationSound.default
    //
    //        // Configure the trigger for a 7am wakeup.
    //        var dateInfo = DateComponents()
    //        dateInfo.hour = 20
    //        dateInfo.minute = 28
    //        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
    //
    //        // Create the request object.
    //        let request = UNNotificationRequest(identifier: "MorningAlarm", content: content, trigger: trigger)
    //        // Schedule the request.
    //        let center = UNUserNotificationCenter.current()
    //        center.add(request) { (error : Error?) in
    //            if let theError = error {
    //                print(theError.localizedDescription)
    //            }
    //        }
    //    }
    //
    //    func userNotificationCenter(_ center: UNUserNotificationCenter,
    //                                willPresent notification: UNNotification,
    //                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    //        completionHandler(UNNotificationPresentationOptions.sound)
    //    }
    
    //MARK: - getNowTime
    
    func getNowDateTime() -> String {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        let date = Date()
        return dateFormatterPrint.string(from: date)
        
    }
}

//MARK: - WeatherManagerDelegate

extension ViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = "\(weather.temperatureString) °C"
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

