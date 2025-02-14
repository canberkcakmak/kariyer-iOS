//
//  Constants.swift
//  Kariyernet
//
//  Created by Canberk Çakmak on 6.02.2025.
//

import Foundation

enum ViewState {
    case home
    case search
    case favorites
}

enum SearchFilter {
    case all
    case artist
    case name
    
    var title: String {
        switch self {
        case .all: return "Tümü"
        case .artist: return "Yazar"
        case .name: return "İsim"
        }
    }
    
    static var allCases: [SearchFilter] = [.all, .artist, .name]
}

enum SortOption: CaseIterable {
    case all
    case favoritesOnly
    case newToOld
    case oldToNew
    
    var title: String {
        switch self {
        case .all:
            return "Tümü"
        case .favoritesOnly:
            return "Sadece beğenilenler"
        case .newToOld:
            return "Yeniden eskiye"
        case .oldToNew:
            return "Eskiden yeniye"
        }
    }
    
    static var favoriteViewOptions: [SortOption] {
        [.newToOld, .oldToNew]
    }
    
    static var normalViewOptions: [SortOption] {
        allCases
    }
}
