//
//  PrayerLocationViewModel.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/15/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation
import NetworkPackage

protocol PrayerLocationViewModel: ViewModel {
    var sectionCount: Int { get }
    var title: String { get }
    var items: [PrayerLocationViewModelItem] { get set }
    var filteredItems: [PrayerLocationViewModelItem] { get set }
    var state: Dynamic<State> { get }
    var completion: ((PrayerLocationViewModelItem) -> Void)? { get set }
    
    func getData()
    func search(text: String)
}

extension PrayerLocationViewModel {
    var sectionCount: Int {
        return 1
    }
}

class PrayerLocationCountriesViewModel: PrayerLocationViewModel {
    var title: String {
        return LocalizedConstants.Prayer.Countries
    }
    var items: [PrayerLocationViewModelItem] = []
    var filteredItems: [PrayerLocationViewModelItem] = []
    var state: Dynamic<State> = Dynamic(State.loading)
    var completion: ((PrayerLocationViewModelItem) -> Void)?
    
    func getData() {
        getCountries()
    }
    
    private func getCountries() {
        state.value = .loading
        
        
        let request = Endpoints.Paths.prayerCountries.asUrlRequest()
        
        APIManager.shared.getDataWithCache(PrayerCountry.self, request: request) { [unowned self] in
            handleResult($0)
        }
        
        func handleResult(_ result: NetworkResult<[PrayerCountry]>) {
            switch result {
            case .success(let items):
                self.items = items.compactMap({ PrayerLocationViewModelItem(name: $0.name, nameEnglish: $0.nameEnglish, id: $0.id) })
                self.filteredItems = self.items
                state.value = self.items.isEmpty ? .empty : .populate
            case .failure(let apiError):
                debugPrint("ApiError: \(apiError)")
                state.value = .error
            default:
                return
            }
        }
    }
    
    func search(text: String) {
        state.value = .loading
        
        let text = text.lowercased()
        if text.isEmpty {
            filteredItems = items
        } else {
            filteredItems = items.filter({$0.name?.lowercased().range(of: text) != nil || $0.nameEnglish?.lowercased().range(of: text) != nil})
        }
        state.value = .populate
    }
}

class PrayerLocationCitiesViewModel: PrayerLocationViewModel {
    var title: String {
        return PersistentManager.shared.isTurkishLanguage ? selectedItem.name : selectedItem.nameEnglish
    }
    var items: [PrayerLocationViewModelItem] = []
    var filteredItems: [PrayerLocationViewModelItem] = []
    var state: Dynamic<State> = Dynamic(State.loading)
    var completion: ((PrayerLocationViewModelItem) -> Void)?
    
    var selectedItem: PrayerLocationViewModelItem
    
    init(_ selectedItem: PrayerLocationViewModelItem) {
        self.selectedItem = selectedItem
    }
    
    func getData() {
        getCities()
    }
    
    private func getCities() {
        state.value = .loading
//        let url = Endpoints.PrayerPaths.cities.url.appendingPathComponent(selectedItem.id)
//
//        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        let queryItems = [URLQueryItem(name: "ulke", value: selectedItem.id)]
        let request = Endpoints.Paths.prayerCities.asUrlRequestWith(query: queryItems)
        APIManager.shared.getDataWithCache(PrayerCity.self, request: request) { [weak self] in
            self?.handleResult($0)
        }
        
        
    }
    
    private func handleResult(_ result: NetworkResult<[PrayerCity]>) {
        switch result {
        case .success(let items):
            self.items = items.compactMap({ PrayerLocationViewModelItem(name: $0.name, nameEnglish: $0.nameEnglish, id: $0.id) })
            self.filteredItems = self.items
            state.value = self.items.isEmpty ? .empty : .populate
        case .failure(let apiError):
            debugPrint("ApiError: \(apiError)")
            state.value = .error
        default:
            return
        }
    }
    
    func search(text: String) {
        state.value = .loading
        
        let text = text.lowercased()
        if text.isEmpty {
            filteredItems = items
        } else {
            filteredItems = items.filter({$0.name?.lowercased().range(of: text) != nil || $0.nameEnglish?.lowercased().range(of: text) != nil})
        }
        state.value = .populate
    }
}

class PrayerLocationCountiesViewModel: PrayerLocationViewModel {
    var title: String {
        return PersistentManager.shared.isTurkishLanguage ? selectedItem.name : selectedItem.nameEnglish
    }
    var items: [PrayerLocationViewModelItem] = []
    var filteredItems: [PrayerLocationViewModelItem] = []
    var state: Dynamic<State> = Dynamic(State.loading)
    var completion: ((PrayerLocationViewModelItem) -> Void)?
    
    var selectedItem: PrayerLocationViewModelItem
    
    init(_ selectedItem: PrayerLocationViewModelItem) {
        self.selectedItem = selectedItem
    }
    
    func getData() {
        getCounties()
    }
    
    private func getCounties() {
        state.value = .loading
        
        let queryItems = [URLQueryItem(name: "sehir", value: selectedItem.id)]
        let request = Endpoints.Paths.prayerCounties.asUrlRequestWith(query: queryItems)
        
        APIManager.shared.getDataWithCache(PrayerCounty.self, request: request) { [weak self] in
            self?.handleResult($0)
        }
        
    }
    
    func handleResult(_ result: NetworkResult<[PrayerCounty]>) {
        switch result {
        case .success(let items):
            self.items = items.compactMap({ PrayerLocationViewModelItem(name: $0.name, nameEnglish: $0.nameEnglish, id: $0.id) })
            self.filteredItems = self.items
            state.value = self.items.isEmpty ? .empty : .populate
        case .failure(let apiError):
            debugPrint("ApiError: \(apiError)")
            state.value = .error
        default:
            return
        }
    }
    
    func search(text: String) {
        state.value = .loading
        
        let text = text.lowercased()
        if text.isEmpty {
            filteredItems = items
        } else {
            filteredItems = items.filter({$0.name?.lowercased().range(of: text) != nil || $0.nameEnglish?.lowercased().range(of: text) != nil})
        }
        state.value = .populate
    }
}

class PrayerLocationViewModelItem: ViewModelItem {
    var name: String!
    var nameEnglish: String!
    var id: String!
    
    var nameText: String {
        return PersistentManager.shared.isTurkishLanguage ? name : nameEnglish
    }
    
    var detailNameText: String {
        return PersistentManager.shared.isTurkishLanguage ? nameEnglish : name
    }
    
    init(name: String, nameEnglish: String, id: String) {
        self.name = name
        self.nameEnglish = nameEnglish
        self.id = id
    }
}
