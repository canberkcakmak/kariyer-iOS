//
//  BooksService.swift
//  Kariyernet
//
//  Created by Canberk Çakmak on 6.02.2025.
//

import Foundation

protocol BooksServiceProtocol {
    func fetchBooks() async throws -> BooksResponse
}

class BooksService: BooksServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    private let baseURL = "https://rss.marketingtools.apple.com/api/v2/us/books/top-free/100/books.json"
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchBooks() async throws -> BooksResponse {
        return try await networkManager.fetch(from: baseURL)
    }
}
