//
//  BookDataCache.swift
//  Kariyernet
//
//  Created by Canberk Çakmak on 14.02.2025.
//

class BookDataCache {
    static let shared = BookDataCache()
    private init() {}
    
    private var cachedBooks: [Book]?
    
    func cacheBooks(_ books: [Book]) {
        cachedBooks = books
    }
    
    func getCachedBooks() -> [Book]? {
        return cachedBooks
    }
    
    func clearCache() {
        cachedBooks = nil
    }
}
