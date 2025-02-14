//
//  BooksViewControllerTests.swift
//  KariyernetTests
//
//  Created by Canberk Çakmak on 14.02.2025.
//

import XCTest
@testable import Kariyernet

class BooksViewControllerTests: XCTestCase {
    var sut: BooksViewController!
    var mockViewModel: MockBooksViewModel!
    
    override func setUp() {
        super.setUp()
        sut = BooksViewController()
        mockViewModel = MockBooksViewModel()
        sut.viewModel = mockViewModel
    }
    
    override func tearDown() {
        sut = nil
        mockViewModel = nil
        super.tearDown()
    }
    
    func testToggleFavorite() {
        // Given
        let testBook = Book.sampleBook
        
        mockViewModel.filteredBooks = [testBook]
        
        // When
        mockViewModel.toggleFavorite(for: testBook)
        
        // Then
        XCTAssertTrue(mockViewModel.toggleFavoriteCalled)
        XCTAssertTrue(mockViewModel.isFavorite(testBook.id))
    }
    
    func testRemoveFromFavorites() {
        // Given
        let testBook = Book.sampleBook
        mockViewModel.viewState = .favorites
        mockViewModel.filteredBooks = [testBook]
        mockViewModel.toggleFavorite(for: testBook)
        
        // When
        mockViewModel.toggleFavorite(for: testBook)
        
        // Then
        XCTAssertTrue(mockViewModel.filteredBooks.isEmpty)
    }
    
    func testCollectionViewDataSource() {
        // Given
        let testBook = Book.sampleBook
        mockViewModel.filteredBooks = [testBook]
        
        // When
        let count = sut.collectionView(sut.collectionView, numberOfItemsInSection: 0)
        
        // Then
        XCTAssertEqual(count, 1)
    }
}
