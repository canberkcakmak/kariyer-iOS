//
//  MockBooksViewModel.swift
//  KariyernetTests
//
//  Created by Canberk Çakmak on 14.02.2025.
//

@testable import Kariyernet

class MockBooksViewModel: BooksViewModel {
    var fetchInitialBooksCalled = false
    var loadNextChunkCalled = false
    var toggleFavoriteCalled = false
    var sortBooksCalled = false
    
    private var mockFavorites: Set<String> = []
    
    override func fetchInitialBooks() {
        fetchInitialBooksCalled = true
    }
    
    override func loadNextChunk() async throws {
        loadNextChunkCalled = true
    }
    
    override func toggleFavorite(for book: Book) {
        toggleFavoriteCalled = true
        
        switch mockFavorites.contains(book.id) {
        case true:
            mockFavorites.remove(book.id)
            
            switch viewState {
            case .favorites:
                if let index = filteredBooks.firstIndex(where: { $0.id == book.id }) {
                    filteredBooks.remove(at: index)
                    delegate?.didRemoveItem(at: index)
                }
            case .home, .search:
                break
            }
            
        case false:
            mockFavorites.insert(book.id)
        }
    }
    
    override func isFavorite(_ id: String) -> Bool {
        return mockFavorites.contains(id)
    }
    
    override func sortBooks(by option: SortOption) {
        sortBooksCalled = true
    }
}
