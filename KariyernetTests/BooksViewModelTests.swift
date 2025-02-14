//
//  BooksViewModelTests.swift
//  KariyernetTests
//
//  Created by Canberk Çakmak on 14.02.2025.
//

import XCTest
@testable import Kariyernet

class BooksViewModelTests: XCTestCase {
    var viewModel: BooksViewModel!
    var mockDelegate: MockBooksViewModelDelegate!
    
    override func setUp() {
        super.setUp()
        viewModel = BooksViewModel()
        mockDelegate = MockBooksViewModelDelegate()
        viewModel.delegate = mockDelegate
    }
    
    override func tearDown() {
        viewModel = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    // MARK: - Fetch Tests
    func testFetchInitialBooksInHomeState() async {
        // Given
        viewModel.viewState = .home
        
        // When
        await viewModel.fetchInitialBooks()
        
        // Then
        XCTAssertFalse(viewModel.books.isEmpty)
        XCTAssertTrue(mockDelegate.didStartLoadingCalled)
        XCTAssertTrue(mockDelegate.didFinishLoadingCalled)
        XCTAssertTrue(mockDelegate.didUpdateBooksCalled)
    }
    
    func testFetchInitialBooksInFavoritesState() async {
        // Given
        viewModel.viewState = .favorites
        
        // When
        await viewModel.fetchInitialBooks()
        
        // Then
        XCTAssertTrue(mockDelegate.didStartLoadingCalled)
        XCTAssertTrue(mockDelegate.didFinishLoadingCalled)
    }
    
    func testSearchBooksWithNameFilter() {
        // Given
        let searchText = "Harry Poter"
        
        // When
        viewModel.searchBooks(with: searchText, filter: .name)
        
        // Then
        XCTAssertTrue(viewModel.filteredBooks.allSatisfy { $0.name.lowercased().contains(searchText) })
    }
    
    // MARK: - Sort Tests
    func testSortBooksNewToOld() {
        // Given
        viewModel.books = [
            Book.sampleBook,
            Book.sampleBook2
        ]
        
        // When
        viewModel.sortBooks(by: .newToOld)
        
        // Then
        XCTAssertTrue(mockDelegate.scrollToTopCalled)
    }
    
    // MARK: - Favorite Tests
    func testToggleFavorite() {
        // Given
        let book = Book.sampleBook
        
        // When
        viewModel.toggleFavorite(for: book)
        
        // Then
        XCTAssertTrue(viewModel.isFavorite(book.id))
        
        // When - toggle again
        viewModel.toggleFavorite(for: book)
        
        // Then
        XCTAssertFalse(viewModel.isFavorite(book.id))
    }
    
    // MARK: - Pagination Tests
    func testLoadNextChunk() async throws {
        // Given
        let initialCount = viewModel.filteredBooks.count
        
        // When
        try await viewModel.loadNextChunk()
        
        // Then
        XCTAssertGreaterThan(viewModel.filteredBooks.count, initialCount)
    }
}
