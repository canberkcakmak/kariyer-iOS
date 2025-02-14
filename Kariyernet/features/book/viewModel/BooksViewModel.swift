//
//  BooksViewModel.swift
//  Kariyernet
//
//  Created by Canberk Çakmak on 6.02.2025.
//

import Foundation
import Combine

protocol BooksViewModelDelegate: AnyObject {
    func didUpdateBooks(reloadAll: Bool)
    func didStartLoading()
    func didFinishLoading()
    func didReceiveError(_ error: String)
    func scrollToTop()
    func didRemoveItem(at index: Int)
}

class BooksViewModel {

    var originalBooks: [Book] = []
    var books: [Book] = []
    var filteredBooks: [Book] = []
    var previousBooks: [Book] = []
    var currentSortOption: SortOption = .all
    var isLoading = false
    
    var viewState: ViewState = .home
    
    private let booksService: BooksServiceProtocol
    private let dataManager: BooksDataManager
    private var cancellables = Set<AnyCancellable>()
    
    private var searchText: String = ""
    private var searchFilter: SearchFilter = .all
    
    private let chunkSize: Int
    private var currentChunkIndex = 0
    
    weak var delegate: BooksViewModelDelegate?
    
    init(
        booksService: BooksServiceProtocol = BooksService(),
        dataManager: BooksDataManager = .shared,
        chunkSize: Int = 10
    ) {
        self.booksService = booksService
        self.dataManager = dataManager
        self.chunkSize = chunkSize
        
        setupBindings()
    }
    
    private func setupBindings() {
        dataManager.favoritesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.handleFavoritesChange()
            }
            .store(in: &cancellables)
    }
    
    private func handleFavoritesChange() {
        switch (viewState, currentSortOption) {
        case (.favorites, _), (_, .favoritesOnly):
            
            filteredBooks.removeAll()
            books.removeAll()
            
            books = dataManager.getFavoriteBooks()
            
            loadInitialChunk()
            
        default:
            delegate?.didUpdateBooks(reloadAll: false)
        }
    }
    
    @MainActor
    func fetchInitialBooks() {
        guard !isLoading else { return }

        isLoading = true
        delegate?.didStartLoading()
        
        Task {
            do {
                switch viewState {
                    case .favorites:
                        let favorites = dataManager.getFavoriteBooks()
                        self.originalBooks = favorites
                        self.books = favorites
                    case .home, .search:
                        if let cachedBooks = BookDataCache.shared.getCachedBooks(), !cachedBooks.isEmpty {
                            self.originalBooks = cachedBooks
                            self.books = cachedBooks
                        }else{
                            let response = try await booksService.fetchBooks()
                            self.originalBooks = response.feed.results
                            self.books = response.feed.results
                            BookDataCache.shared.cacheBooks(response.feed.results)
                    }
                }
                
                self.currentChunkIndex = 0
                applyCurrentSorting()
                loadInitialChunk()
                
            } catch {
                delegate?.didReceiveError(error.localizedDescription)
            }
            
            isLoading = false
            delegate?.didFinishLoading()
        }
    }
    
    private func loadInitialChunk() {
        filteredBooks.removeAll()
        
        let endIndex = min(chunkSize, books.count)
        filteredBooks = Array(books[0..<endIndex])
        currentChunkIndex = 1
        delegate?.didUpdateBooks(reloadAll: true)
    }
    
    @MainActor
    func loadNextChunk() async throws {
        guard !isLoading && canLoadMore() else { return }
        
        isLoading = true
        
        let startIndex = currentChunkIndex * chunkSize
        let endIndex = min((currentChunkIndex + 1) * chunkSize, books.count)
        
        let newChunk = Array(books[startIndex..<endIndex])
        filteredBooks.append(contentsOf: newChunk)
        currentChunkIndex += 1
        
        isLoading = false
        delegate?.didUpdateBooks(reloadAll: false)
    }
    
    func toggleFavorite(for book: Book) {
        if dataManager.isFavorite(book.id) {
            switch viewState {
            case .favorites:
                dataManager.deleteFavorite(book.id)
                
                if let index = books.firstIndex(where: { $0.id == book.id }) {
                    books.remove(at: index)
                }
                if let filteredIndex = filteredBooks.firstIndex(where: { $0.id == book.id }) {
                    filteredBooks.remove(at: filteredIndex)
                    delegate?.didRemoveItem(at: filteredIndex)
                }
            case .home, .search:
                dataManager.deleteFavorite(book.id)
            }
        } else {
            dataManager.saveFavorite(book)
        }
    }
    
    func searchBooks(with query: String, filter: SearchFilter) {
        searchText = query
        searchFilter = filter
        
        guard !query.isEmpty else {
            books = originalBooks
            loadInitialChunk()
            return
        }
        
        let searchQuery = query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let searchResults = originalBooks.filter { book in
            switch filter {
            case .all:
                return book.name.lowercased().contains(searchQuery) ||
                book.artistName.lowercased().contains(searchQuery)
            case .artist:
                return book.artistName.lowercased().contains(searchQuery)
            case .name:
                return book.name.lowercased().contains(searchQuery)
            }
        }
        
        books = searchResults
        loadInitialChunk()
    }
    
    func sortBooks(by option: SortOption) {
        guard currentSortOption != option else { return }
        
        currentSortOption = option
        applyCurrentSorting()
        loadInitialChunk()
        delegate?.scrollToTop()
    }
    
    private func applyCurrentSorting() {
        switch currentSortOption {
        case .all:
            books = originalBooks
        case .newToOld:
            books.sort { $0.releaseDate > $1.releaseDate }
        case .oldToNew:
            books.sort { $0.releaseDate < $1.releaseDate }
        case .favoritesOnly:
            books = dataManager.getFavoriteBooks()
        }
    }
    
    func canLoadMore() -> Bool {
        return currentChunkIndex * chunkSize < books.count
    }
    
    func isFavorite(_ bookId: String) -> Bool {
        return dataManager.isFavorite(bookId)
    }
}
