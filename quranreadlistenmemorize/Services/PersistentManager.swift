//
//  PersistentManager.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/13/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation
import CoreData
import NetworkPackage

class PersistentManager {
    
    static let shared = PersistentManager()
    
    let turkishSurahNames = ["Fâtiha", "Bakara", "Âl-i İmrân", "Nisâ", "Mâide", "En'âm", "A'râf", "Enfâl", "Tevbe", "Yunus", "Hûd", "Yusuf", "Ra'd", "İbrahim", "Hicr", "Nahl", "İsrâ", "Kehf", "Meryem", "Tâ-Hâ", "Enbiyâ", "Hac", "Mü'minûn", "Nûr", "Furkan", "Şuarâ", "Neml", "Kasas", "Ankebût", "Rûm", "Lokman", "Secde", "Ahzâb", "Sebe'", "Fâtır", "Yâsin", "Sâffât", "Sâd", "Zümer", "Mü'min", "Fussilet", "Şûrâ", "Zuhruf", "Duhân", "Câsiye", "Ahkaf", "Muhammed", "Fetih", "Hucurât", "Kaf", "Zâriyât", "Tûr", "Necm", "Kamer", "Rahmân", "Vâkıa", "Hadid", "Mücâdele", "Haşr", "Mümtehine", "Saf", "Cum'a", "Münâfikûn", "Teğabün", "Talâk", "Tahrim", "Mülk", "Kalem", "Hâkka", "Meâric", "Nuh", "Cin", "Müzzemmil", "Müddessir", "Kıyamet", "İnsan", "Mürselât", "Nebe'", "Nâziât", "Abese", "Tekvir", "İnfitâr", "Mutaffifin", "İnşikak", "Bürûc", "Târık", "A'lâ", "Gâşiye", "Fecr", "Beled", "Şems", "Leyl", "Duhâ", "İnşirâh", "Tin", "Alak", "Kadir", "Beyyine", "Zilzâl", "Âdiyât", "Kâria", "Tekâsür", "Asr", "Hümeze", "Fil", "Kureyş", "Mâûn", "Kevser", "Kâfirûn", "Nasr", "Tebbet", "İhlâs", "Felâk", "Nâs"]
    
    let minutesBefore = [5, 10, 15, 20, 25, 30, 45, 60, 90, 120]
    
    var isTurkishLanguage: Bool {
        return Locale.current.languageCode?.lowercased() == Constants.Language.Turkish ? true : false
    }
    
    var isArabicLanguage: Bool {
        return Locale.current.languageCode?.lowercased() == Constants.Language.Arabic ? true : false
    }
    
    var appConfiguration: AppConfigurationMO {
        return fetch(AppConfigurationMO.self)[0]
    }
    
    var defaultPrayerSound: PrayerSoundMO {
        return fetch(PrayerSoundMO.self).filter( { $0.name == Constants.DefaultSoundName })[0]
    }
    
    var selectedQuran: Quran? {
        if appConfiguration.edition.identifier == QuranType.diyanet.identifier() {
            return FileOperationManager.shared.getQuranFromResource(quranType: .diyanet)
        }
        return FileOperationManager.shared.getQuranDownloaded(appConfiguration.edition.identifier)
    }
    
    lazy var quranUthmani: Quran? = {
        return FileOperationManager.shared.getQuranFromResource(quranType: .quranUthmani)
    }()
    
    lazy var transliteration: Quran? = {
        if appConfiguration.edition.identifier.hasPrefix(Constants.Language.Turkish) {
            return FileOperationManager.shared.getQuranFromResource(quranType: .turkishTransliteration)
        }
        return FileOperationManager.shared.getQuranFromResource(quranType: .englishTransliteration)
    }()
    
    func isBundleFile(_ identifier: String) -> Bool {
        return identifier == QuranType.diyanet.identifier()
    }
    
    lazy var context = persistentContainer.viewContext
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "quranreadlistenmemorize")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data Fetch
    func fetch<T: NSManagedObject>(_ type: T.Type) -> [T] {
        do {
            if let fetchedObjects = try context.fetch(T.fetchRequest()) as? [T] {
                return fetchedObjects
            }
        } catch {
            debugPrint("Fetch for type: \(type) - error: \(error)")
        }
        return [T]()
    }
    
    // MARK: Core Data Delete
    func delete(_ object: NSManagedObject) {
        context.delete(object)
    }
    
    
    enum TimeNotificationType: String {
        case beforeTimeFajr
        case beforeTimeSunrise
        case beforeTimeDhuhr
        case beforeTimeAsr
        case beforeTimeMaghrib
        case beforeTimeIsha
    }
    
    func coreDataAppConfiguration() {
        guard fetch(AppConfigurationMO.self).isEmpty else { return }
        
        createEditionsCoreData()
        createSoundsCoreData()
        createPrayerNotificationsCoreData()
        createDhikrsCoreData()
        
        // Create App Configuration
        createAppConfigurationEntity()
        saveContext()
    }
    
    private func createAppConfigurationEntity() {
        let editions = fetch(EditionMO.self).filter({ $0.identifier == QuranType.diyanet.identifier()})
        
        let object = AppConfigurationMO(context: context)
        object.selectedAudioEditionId = Constants.AudioEditionId
        if let editionDiyanet = editions.first {
            object.edition = editionDiyanet
        }
    }
    
    private func createEditionsCoreData() {
        let editions = FileOperationManager.shared.getQuranEditions()
        editions.forEach({ createEditionEntity(edition: $0) })
    }
    
    private func createEditionEntity(edition: Edition) {
        let editionObject = EditionMO(context: context)
        editionObject.identifier = edition.identifier
        editionObject.language = edition.language
        editionObject.name = edition.name
        editionObject.englishName = edition.englishName
        editionObject.format = edition.format
        editionObject.type = edition.type
    }
    
    private func createPrayerNotificationsCoreData() {
        // before time prayer times object create
        createPrayerNotificationEntity(id: 1, name: PrayerTimeType.fajr.rawValue)
        createPrayerNotificationEntity(id: 2, name: PrayerTimeType.sunrise.rawValue)
        createPrayerNotificationEntity(id: 3, name: PrayerTimeType.dhuhr.rawValue)
        createPrayerNotificationEntity(id: 4, name: PrayerTimeType.asr.rawValue)
        createPrayerNotificationEntity(id: 5, name: PrayerTimeType.maghrib.rawValue)
        createPrayerNotificationEntity(id: 6, name: PrayerTimeType.isha.rawValue)
        
        // in time prayer times object create
        createPrayerNotificationEntity(id: 7, name: PrayerTimeType.fajr.rawValue, minutesBefore: 0)
        createPrayerNotificationEntity(id: 8, name: PrayerTimeType.sunrise.rawValue, minutesBefore: 0)
        createPrayerNotificationEntity(id: 9, name: PrayerTimeType.dhuhr.rawValue, minutesBefore: 0)
        createPrayerNotificationEntity(id: 10, name: PrayerTimeType.asr.rawValue, minutesBefore: 0)
        createPrayerNotificationEntity(id: 11, name: PrayerTimeType.maghrib.rawValue, minutesBefore: 0)
        createPrayerNotificationEntity(id: 12, name: PrayerTimeType.isha.rawValue, minutesBefore: 0)
    }
    
    private func createPrayerNotificationEntity(id: Int16, name: String, status: Bool = false, minutesBefore: Int16 = 30) {
        let object = PrayerNotificationMO(context: context)
        object.id = id
        object.name = name
        object.status = status
        object.minutesBefore = minutesBefore
        object.sound = defaultPrayerSound
    }
    
    private func createDhikrsCoreData() {
        // move dhikrs to core date
        let dhikrs = FileOperationManager.shared.getDhikrsFromResource()
        dhikrs?.forEach({ createDhikrEntity($0)})
    }
    
    private func createDhikrEntity(_ dhikr: Dhikr) {
        let object = DhikrMO(context: context)
        object.name = dhikr.name
        object.reading = dhikr.reading
        object.meaning = dhikr.meaning
        object.uthmani = dhikr.uthmani
        object.remainingCount = Int16(dhikr.remainingCount)
        object.roundCount = Int16(dhikr.roundCount)
        object.totalCount = Int16(Constants.MaxDhikrCount)
        object.isSoundOn = true
    }
    
    private func createSoundsCoreData() {
        createSoundEntity(Constants.DefaultSoundName, "PrayerSoundDefault")
        createSoundEntity("bismillah.caf", "PrayerSoundBismillah")
        createSoundEntity("assalatu.caf", "PrayerSoundAssalatu")
        createSoundEntity("azan1.caf", "PrayerSoundAzanFirst")
        createSoundEntity("azan2.caf", "PrayerSoundAzanSecond")
        createSoundEntity("melody1.caf", "PrayerSoundMelodiFirst")
        createSoundEntity("melody2.caf", "PrayerSoundMelodiSecond")
    }
    
    private func createSoundEntity(_ name: String, _ localizedKey: String) {
        let prayerSoundMO = PrayerSoundMO(context: context)
        prayerSoundMO.name = name
        prayerSoundMO.localizedKey = localizedKey
    }
}

extension PersistentManager {
    
    func schedulePrayerTimesNotification() {
        
        let prayerNotifications = fetch(PrayerNotificationMO.self).sorted(by: { $0.id < $1.id })
        let prayerTimes = fetch(PrayerTimeMO.self).sorted(by: { $0.gregorianDate < $1.gregorianDate })
        
        NotificationManager.shared.removeAllNotifications()
        prayerNotifications
            .filter({$0.status == true})
            .forEach { (prayerNotification) in
                prayerTimes.forEach({ (prayerTime) in
                    NotificationManager.shared.scheduleLocal(prayerNotification: prayerNotification, prayerTime: prayerTime)
                })
        }
      
    }
    
    func getAndRefreshPrayerTimesData() {
        guard let expireDate = appConfiguration.prayerTimesExpireDate, expireDate < Formatter.shared.currentDate else { return }
        getMonthlyPrayerTimes()
    }
    
    // call from PrayerTimeViewController
    func getMonthlyPrayerTimes() {
        guard let selectedCounty = appConfiguration.county else {
            return
        }
        
        let queryItems = [URLQueryItem(name: "ilce", value: selectedCounty.id)]
        let request = Endpoints.Paths.prayerTimes.asUrlRequestWith(query: queryItems)
        
        APIManager.shared.getDataWithNoCache(PrayerTime.self, request: request) { (result) in
            switch result {
            case .success(let items):
                self.savePrayerTimeToCoreData(prayerTimes: items)
            case .failure(let apiError):
                debugPrint("ApiError: \(apiError)")
            default:
                return
            }
        }
    }
    
    func savePrayerTimeToCoreData(prayerTimes: [PrayerTime]) {
        guard !prayerTimes.isEmpty else { return }
        
        // clear core data
        fetch(PrayerTimeMO.self).forEach({ delete($0) })
        
        // save core data
        prayerTimes.forEach({ createPrayerTimeMO($0) })
        saveContext()
        
        // TODO: acilacak
        let newExpireDate = Calendar.current.date(byAdding: .day, value: Constants.Cache.ExpireDay, to: Formatter.shared.currentDate)
        appConfiguration.prayerTimesExpireDate = newExpireDate
        
        schedulePrayerTimesNotification()
    }
    
    
    func createPrayerTimeMO(_ prayerTime: PrayerTime) {
        let prayerTimeMO = PrayerTimeMO(context: context)
        prayerTimeMO.gregorianDate = Formatter.shared.getDateFrom(prayerTime, .isha)
        prayerTimeMO.hijriDateString = prayerTime.hijriDate
        
        prayerTimeMO.fajrDate = Formatter.shared.getDateFrom(prayerTime, .fajr)
        prayerTimeMO.sunriseDate = Formatter.shared.getDateFrom(prayerTime, .sunrise)
        prayerTimeMO.dhuhrDate = Formatter.shared.getDateFrom(prayerTime, .dhuhr)
        prayerTimeMO.asrDate = Formatter.shared.getDateFrom(prayerTime, .asr)
        prayerTimeMO.maghribDate = Formatter.shared.getDateFrom(prayerTime, .maghrib)
        prayerTimeMO.ishaDate = Formatter.shared.getDateFrom(prayerTime, .isha)
    }
    
    func saveSelectedLocationToCoreData(country: PrayerLocationViewModelItem, city: PrayerLocationViewModelItem, county: PrayerLocationViewModelItem) {
        
        // if exists delete selected locations
        fetch(PrayerLocationMO.self).forEach({ delete($0) })
        
        // create new location
        appConfiguration.country = createPrayerLocationEntity(id: country.id, name: country.name, nameEnglish: country.nameEnglish)
        appConfiguration.city = createPrayerLocationEntity(id: city.id, name: city.name, nameEnglish: city.nameEnglish)
        appConfiguration.county = createPrayerLocationEntity(id: county.id, name: county.name, nameEnglish: county.nameEnglish)
        
        saveContext()
    }
    
    private func createPrayerLocationEntity(id: String, name: String, nameEnglish: String) -> PrayerLocationMO {
        let object = PrayerLocationMO(context: context)
        object.id = id
        object.name = name
        object.nameEnglish = nameEnglish
        return object
    }
    
    /// remove all location and related prayer times
    func removeLocationAndPrayerTimes() {
        fetch(PrayerLocationMO.self).forEach({ delete($0) })
        fetch(PrayerTimeMO.self).forEach({ delete($0) })
        saveContext()
    }
}
