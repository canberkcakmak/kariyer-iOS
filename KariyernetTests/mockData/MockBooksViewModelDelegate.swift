//
//  MockBooksViewModelDelegate.swift
//  KariyernetTests
//
//  Created by Canberk Çakmak on 14.02.2025.
//

@testable import Kariyernet

class MockBooksViewModelDelegate: BooksViewModelDelegate {
    var didUpdateBooksCalled = false
    var didStartLoadingCalled = false
    var didFinishLoadingCalled = false
    var didReceiveErrorCalled = false
    var scrollToTopCalled = false
    var didRemoveItemCalled = false
    var lastErrorMessage: String?
    var lastRemovedIndex: Int?
    
    func didUpdateBooks(reloadAll: Bool) {
        didUpdateBooksCalled = true
    }
    
    func didStartLoading() {
        didStartLoadingCalled = true
    }
    
    func didFinishLoading() {
        didFinishLoadingCalled = true
    }
    
    func didReceiveError(_ error: String) {
        didReceiveErrorCalled = true
        lastErrorMessage = error
    }
    
    func scrollToTop() {
        scrollToTopCalled = true
    }
    
    func didRemoveItem(at index: Int) {
        didRemoveItemCalled = true
        lastRemovedIndex = index
    }
}
