//
//  ViewController.swift
//  Kariyernet
//
//  Created by Canberk Çakmak on 6.02.2025.
//

import UIKit


class BaseViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let booksVC = createTabItem(viewController: BooksViewController(), title: "Tümü", imageName: "book", tag: 0)
        (booksVC.viewControllers.first as? BooksViewController)?.viewModel.viewState = .home

        let searchBooksVC = createTabItem(viewController: BookSearchViewController(), title: "Arama", imageName: "magnifyingglass", tag: 1)
        (searchBooksVC.viewControllers.first as? BookSearchViewController)?.viewModel.viewState = .search

        let favoriteBooksVC = createTabItem(viewController: BooksViewController(), title: "Beğenilenler", imageName: "star", tag: 2)
        (favoriteBooksVC.viewControllers.first as? BooksViewController)?.viewModel.viewState = .favorites

        viewControllers = [booksVC, searchBooksVC, favoriteBooksVC]
    }
    
    private func createTabItem(viewController: UIViewController, title: String, imageName: String, tag: Int) -> UINavigationController {
        viewController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageName), tag: tag)
        return UINavigationController(rootViewController: viewController)
    }
}
