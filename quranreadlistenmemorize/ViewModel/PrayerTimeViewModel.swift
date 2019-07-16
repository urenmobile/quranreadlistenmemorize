//
//  PrayerTimeViewModel.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/15/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation
import CoreData

class PrayerTimeViewModel: BaseViewModel {
    var items = [[ViewModelItem]]()
    let state = Dynamic(State.loading)
    
    let locationItem = PrayerTimeViewModelItemLocation()
    let timerItem = PrayerTimerViewModelItemTimer()
    
    // Locaion Selection
    var selectedCountry: PrayerLocationViewModelItem?
    var selectedCity: PrayerLocationViewModelItem?
    var selectedCounty: PrayerLocationViewModelItem?
    
    let locationSection = 0
    let montlyPrayerTimeSection = 1
    
    //
    lazy var fetchedResultController: NSFetchedResultsController<PrayerTimeMO> = {
        var fetchRequest: NSFetchRequest<PrayerTimeMO> = PrayerTimeMO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "gregorianDate", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "gregorianDate >= %@", Formatter.shared.currentDate as NSDate)
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PersistentManager.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        return fetchedResultController
    }()
    
    override func setup() {
        super.setup()
        self.items.insert([locationItem], at: locationSection)
        
        do {
            try fetchedResultController.performFetch()
        } catch let error {
            debugPrint("ERROR: \(error)")
        }
    }
    
    func footerTitleFor(section: Int) -> String? {
        // if country selected then nil to footer
        if section == locationSection {
            return locationItem.county == nil ? LocalizedConstants.Prayer.SelectLocationFooter : LocalizedConstants.Prayer.TodayLocationFooter
        }
        return nil
    }
    
    func headerTitleFor(section: Int) -> String {
        if section == locationSection {
            return LocalizedConstants.Prayer.SelectLocationHeader.uppercased()
        }
        return LocalizedConstants.Prayer.MonthlyPrayerTimes.uppercased()
    }
    
    func removeLocationAndPrayerTimes() {
        state.value = .loading
        PersistentManager.shared.removeLocationAndPrayerTimes()
        items.removeAll()
        self.items.insert([locationItem], at: locationSection)
        state.value = .populate
    }
    
    func getPrayerTimes() {
        state.value = .loading
        
        let currentDate = Formatter.shared.currentDate
        
        let prayerTimes = PersistentManager.shared.fetch(PrayerTimeMO.self).sorted(by: { $0.gregorianDate < $1.gregorianDate }).filter({ $0.gregorianDate >= currentDate })
        
        if prayerTimes.isEmpty {
             state.value = .empty
            return
        }
        items.removeAll()
        
        if let todayPrayerTime = prayerTimes.first {
            arrangeTodayItem(prayerTime: todayPrayerTime)
        }
        
        timerItem.prayerTime = prayerTimes.first
        timerItem.nextDayPrayerTime = prayerTimes[1]
        
        let viewModelItems = prayerTimes.compactMap({PrayerTimeViewModelItem(prayerTime: $0)})
        items.insert(viewModelItems, at: montlyPrayerTimeSection)
        
        state.value = items.isEmpty ? .empty : .populate
    }
    
    private func arrangeTodayItem(prayerTime: PrayerTimeMO) {
        let fajrItem = PrayerTimeViewModelItemToday(type: .fajr, prayerTime: prayerTime)
        let sunriseItem = PrayerTimeViewModelItemToday(type: .sunrise, prayerTime: prayerTime)
        let dhuhrItem = PrayerTimeViewModelItemToday(type: .dhuhr, prayerTime: prayerTime)
        let asrItem = PrayerTimeViewModelItemToday(type: .asr, prayerTime: prayerTime)
        let maghribItem = PrayerTimeViewModelItemToday(type: .maghrib, prayerTime: prayerTime)
        let ishaItem = PrayerTimeViewModelItemToday(type: .isha, prayerTime: prayerTime)
        
        items.insert([locationItem, timerItem, fajrItem, sunriseItem, dhuhrItem, asrItem, maghribItem, ishaItem], at: locationSection)
    }
    
    func saveAndGetPrayerTimes() {
        guard let country = selectedCountry, let city = selectedCity, let county = selectedCounty  else { return }
        
        PersistentManager.shared.saveSelectedLocationToCoreData(country: country, city: city, county: county)
        PersistentManager.shared.getMonthlyPrayerTimes()
    }
    
}

extension PrayerTimeViewModel: NSFetchedResultsControllerDelegate {
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//
//        switch type {
//        case .insert:
//            print("NSFetchedResultsControllerDelegate insert: \(newIndexPath!)")
//            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
//        case .delete:
//            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
//            print("NSFetchedResultsControllerDelegate delete: \(indexPath!)")
//        case .update:
//            print("NSFetchedResultsControllerDelegate update: \(indexPath!)")
//        case .move:
//            print("NSFetchedResultsControllerDelegate move: \(indexPath!)")
//        default:
//            break
//        }
//    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
        getPrayerTimes()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
    }
}


class PrayerTimeViewModelItemLocation: ViewModelItem {
    var country: PrayerLocationMO? {
        return PersistentManager.shared.appConfiguration.country
    }
    var city: PrayerLocationMO? {
        return PersistentManager.shared.appConfiguration.city
    }
    
    var county: PrayerLocationMO? {
        return PersistentManager.shared.appConfiguration.county
    }
    
    func locationTitleText() -> String? {
        guard let county = county else {
            return LocalizedConstants.Prayer.SelectLocation
        }
        return PersistentManager.shared.isTurkishLanguage ? county.name : county.nameEnglish
    }
    
    func locationSubTitleText() -> String? {
        guard let country = country, let city = city else { return nil }
        let space = " "
        return PersistentManager.shared.isTurkishLanguage ? city.name + space + country.name : city.nameEnglish + space + country.nameEnglish
    }
    
}

class PrayerTimeViewModelItem: ViewModelItem {
    var prayerTime: PrayerTimeMO
    
    init(prayerTime: PrayerTimeMO) {
        self.prayerTime = prayerTime
    }
}

class PrayerTimeViewModelItemToday: ViewModelItem {
    var type: PrayerTimeType
    var prayerTime: PrayerTimeMO
    
    init(type: PrayerTimeType, prayerTime: PrayerTimeMO) {
        self.type = type
        self.prayerTime = prayerTime
    }
    
    func timeText() -> String? {
        switch type {
        case .fajr:
            return timeString(prayerTime.fajrDate)
        case .sunrise:
            return timeString(prayerTime.sunriseDate)
        case .dhuhr:
            return timeString(prayerTime.dhuhrDate)
        case .asr:
            return timeString(prayerTime.asrDate)
        case .maghrib:
            return timeString(prayerTime.maghribDate)
        case .isha:
            return timeString(prayerTime.ishaDate)
        }
    }
    
    private func timeString(_ date: Date) -> String {
        return Formatter.shared.hourMinuteDateFormatter.string(from: date)
    }
}

class PrayerTimerViewModelItemTimer: ViewModelItem {
    var prayerTime: PrayerTimeMO?
    var nextDayPrayerTime: PrayerTimeMO?
    
    func findNearestPrayerTimeInterval() -> TimeInterval {
        if let prayerTime = prayerTime, let prayerTimeType = findNearestPrayerTimeType() {
            return Formatter.shared.getTimeInterval(prayerTime, prayerTimeType)
        }
        
        if let nextDayPrayerTime = nextDayPrayerTime {
            return Formatter.shared.getTimeInterval(nextDayPrayerTime, .fajr)
        }
        
        return 0
    }
    
    func findNearestPrayerTimeType() -> PrayerTimeType? {
        guard let prayerTime = prayerTime else { return nil}
        
        for enumItem in PrayerTimeType.allCases {
            let timeInterval = Formatter.shared.getTimeInterval(prayerTime, enumItem)
            if timeInterval > 0 {
                return enumItem
            }
        }
        // find next day fajr
        return nil
    }
}
