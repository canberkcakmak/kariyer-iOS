//
//  BookSearchViewController.swift
//  Kariyernet
//
//  Created by Canberk Çakmak on 14.02.2025.
//

import Foundation
import UIKit
import SwiftUI

class BookSearchViewController: UIViewController {
    let viewModel = BooksViewModel()
    var currentFilter: SearchFilter = .all
    var searchTimer: Timer?
    let emptyStateView = EmptyStateView()

    private let searchController = UISearchController(searchResultsController: nil)
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.reuseIdentifier)
        table.separatorStyle = .none
        table.backgroundColor = .systemBackground
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 140
        return table
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(SearchFilter.all.title, for: .normal)
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewState = .search
        viewModel.delegate = self
        setupUI()
        setupSearchController()
        setupFilterMenu()
        viewModel.fetchInitialBooks()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Arama"
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func updateEmptyState() {
        let isEmpty = viewModel.filteredBooks.isEmpty
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Ara..."
        
        searchController.searchBar.showsSearchResultsButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
    }
    
    private func setupFilterMenu() {
        let actions = SearchFilter.allCases.map { filter in
            UIAction(title: filter.title) { [weak self] _ in
                self?.currentFilter = filter
                self?.filterButton.setTitle(filter.title, for: .normal)
                if let searchText = self?.searchController.searchBar.text {
                    self?.performSearch(with: searchText)
                }
            }
        }
        
        filterButton.menu = UIMenu(children: actions)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: filterButton)
    }
    
    func performSearch(with query: String) {
        viewModel.searchBooks(with: query, filter: currentFilter)
    }
}

extension BookSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.reuseIdentifier, for: indexPath) as? BookTableViewCell else {
            return UITableViewCell()
        }
        
        guard indexPath.row < viewModel.filteredBooks.count else { return cell }
        
        let book = viewModel.filteredBooks[indexPath.row]
        cell.configure(with: book)
        cell.contentView.layoutIfNeeded()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.filteredBooks.count else { return }
        
        let selectedBook = viewModel.filteredBooks[indexPath.row]
        let detailView = BookDetailView(
            book: selectedBook,
            isFavorite: viewModel.isFavorite(selectedBook.id)
        ) { [weak self] in
            self?.viewModel.toggleFavorite(for: selectedBook)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        let hostingController = UIHostingController(rootView: detailView)
        hostingController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(hostingController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = viewModel.filteredBooks.count - 1
        if indexPath.row == lastItem && viewModel.canLoadMore() {
            Task {
                try? await viewModel.loadNextChunk()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

extension BookSearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        searchTimer?.invalidate()
        if let text = searchController.searchBar.text, !text.isEmpty {
            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.performSearch(with: text)
            }
        }else{
            self.performSearch(with: "")
        }
    }
}

extension BookSearchViewController: BooksViewModelDelegate {
    func didRemoveItem(at index: Int) {}
    
    func scrollToTop() {
        tableView.setContentOffset(.zero, animated: true)
    }
    
    func didUpdateBooks(reloadAll: Bool) {
        DispatchQueue.main.async {
            if self.viewModel.filteredBooks.count == self.tableView.numberOfRows(inSection: 0) {
                return
            }
            self.tableView.reloadData()
            self.updateEmptyState()
        }
    }
    
    func didStartLoading() {
        activityIndicator.startAnimating()
    }
    
    func didFinishLoading() {
        activityIndicator.stopAnimating()
    }
    
    func didReceiveError(_ error: String) {
        showError(error)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Hata",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}
