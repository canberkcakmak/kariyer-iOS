//
//  BookSearchViewControllerTests.swift
//  KariyernetTests
//
//  Created by Canberk Çakmak on 14.02.2025.
//

import XCTest
@testable import Kariyernet

class BookSearchViewControllerTests: XCTestCase {
    var sut: BookSearchViewController!
    
    override func setUp() {
        super.setUp()
        sut = BookSearchViewController()
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testSearchFunction() {
        // Given
        let searchController = sut.navigationItem.searchController
        let searchText = "Harry Potter"
        
        // When
        searchController?.searchBar.text = searchText
        sut.updateSearchResults(for: searchController!)
        
        // Then
        XCTAssertNotNil(sut.searchTimer)
    }
    
    func testFilterChange() {
        // Given
        let initialFilter = sut.currentFilter
        
        // When
        sut.currentFilter = .name
        
        // Then
        XCTAssertNotEqual(initialFilter, sut.currentFilter)
    }
    
    func testLoadMoreBooks() {
        // Given
        let book = Book.sampleBook
        sut.viewModel.filteredBooks = [book]
        
        // When - Then
        XCTAssertEqual(sut.viewModel.filteredBooks.count, 1)
    }
    
    func testViewModelDelegateUpdates() {
        // Given
        let book = Book.sampleBook
        
        // When
        sut.viewModel.filteredBooks = [book]
        sut.didUpdateBooks(reloadAll: true)
        
        // Then
        XCTAssertFalse(sut.emptyStateView.isHidden)
    }
    
    func testSearchFilterUpdate() {
        // Given
        sut.currentFilter = .all
        
        // When
        sut.performSearch(with: "Test")
        
        // Then
        XCTAssertEqual(sut.currentFilter, .all)
    }
}
