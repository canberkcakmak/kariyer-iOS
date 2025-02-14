//
//  MainViewController.swift
//  Kariyernet
//
//  Created by Canberk Çakmak on 6.02.2025.
//

import UIKit
import SwiftUI

class BooksViewController: UIViewController {
    
    var viewModel = BooksViewModel()
    var collectionView: UICollectionView!
    let spacing: CGFloat = 10
    let itemWidth = (UIScreen.main.bounds.width - 30) / 2
    let emptyStateView = EmptyStateView()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationItems()
        viewModel.delegate = self
        viewModel.fetchInitialBooks()
    }
    
    private func setupUI() {
        let layout = UICollectionViewFlowLayout()

        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.6)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(BookCell.self, forCellWithReuseIdentifier: BookCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    
    }
    
    func updateEmptyState() {
        let isEmpty = viewModel.filteredBooks.isEmpty
        emptyStateView.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
    }
    
    private func setupNavigationItems() {
        navigationItem.title = "Kitaplar"
        
        let sortButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down"),
            style: .plain,
            target: self,
            action: #selector(showSortOptions)
        )
        
        switch viewModel.viewState {
        case .home:
            let searchButton = UIBarButtonItem(
                image: UIImage(systemName: "magnifyingglass"),
                style: .plain,
                target: self,
                action: #selector(searchTapped)
            )
            navigationItem.rightBarButtonItems = [sortButton, searchButton]
        default:
            navigationItem.rightBarButtonItems = [sortButton]
        }
    }
    
    @objc func searchTapped() {
        tabBarController?.selectedIndex = 1
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
    
    @objc private func showSortOptions() {
        let alert = UIAlertController(title: "Sırala", message: nil, preferredStyle: .actionSheet)
        
        var options: [SortOption]
        switch viewModel.viewState {
        case .favorites:
            options = SortOption.favoriteViewOptions
        default:
            options = SortOption.normalViewOptions
        }
        
        options.forEach { option in
            alert.addAction(UIAlertAction(title: option.title, style: .default) { [weak self] _ in
                self?.viewModel.sortBooks(by: option)
            })
        }
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        present(alert, animated: true)
    }
}

extension BooksViewController: BooksViewModelDelegate {
    
    func didRemoveItem(at index: Int) {
        collectionView.performBatchUpdates {
            collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        } completion: { _ in
            self.updateEmptyState()
        }
    }
    
    func scrollToTop() {
        collectionView.setContentOffset(.zero, animated: true)
    }
    
    func didUpdateBooks(reloadAll: Bool) {
        DispatchQueue.main.async {
            if reloadAll {
                self.collectionView.reloadData()
            } else {
                let currentCount = self.collectionView.numberOfItems(inSection: 0)
                let newCount = self.viewModel.filteredBooks.count
                
                if currentCount == 0 {
                    self.collectionView.reloadData()
                } else if newCount > currentCount {
                    let indexPaths = (currentCount..<newCount).map {
                        IndexPath(item: $0, section: 0)
                    }
                    self.collectionView.insertItems(at: indexPaths)
                } else {
                    self.collectionView.reloadData()
                }
            }
            
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
}

extension BooksViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.reuseIdentifier, for: indexPath) as? BookCell else {
            return UICollectionViewCell()
        }
        
        guard indexPath.item < viewModel.filteredBooks.count else { return cell }
        
        let book = viewModel.filteredBooks[indexPath.item]
        cell.configure(
            with: book,
            isFavorite: viewModel.isFavorite(book.id), 
            width: itemWidth, height: itemWidth * 1.2
        ) { [weak self] in
            self?.viewModel.toggleFavorite(for: book)
            collectionView.reloadItems(at: [indexPath])
        }
        
        return cell
    }
}

extension BooksViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = viewModel.filteredBooks.count - 1
        if indexPath.item == lastItem && viewModel.canLoadMore() {
            Task {
                try? await viewModel.loadNextChunk()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < viewModel.filteredBooks.count else { return }
        
        let selectedBook = viewModel.filteredBooks[indexPath.item]
        let detailView = BookDetailView(
            book: selectedBook,
            isFavorite: viewModel.isFavorite(selectedBook.id)
        ) { [weak self] in
            self?.viewModel.toggleFavorite(for: selectedBook)
            collectionView.reloadItems(at: [indexPath])
        }
        
        let hostingController = UIHostingController(rootView: detailView)
        hostingController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(hostingController, animated: true)
    }
}
