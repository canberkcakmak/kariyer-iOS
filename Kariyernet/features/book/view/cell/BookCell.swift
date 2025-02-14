//
//  BookCell.swift
//  Kariyernet
//
//  Created by Canberk Çakmak on 14.02.2025.
//

import UIKit
import SwiftUI

class BookCell: UICollectionViewCell {
    static let reuseIdentifier = "BookCell"
    
    private var hostingController: UIHostingController<BookCellView>?
    private var onFavoriteToggle: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with book: Book, isFavorite: Bool, width: CGFloat, height: CGFloat, onFavoriteToggle: @escaping () -> Void) {

        hostingController?.view.removeFromSuperview()
        hostingController = nil
        
        self.onFavoriteToggle = onFavoriteToggle
        
        let bookCellView = BookCellView(
            book: book,
            isFavorite: isFavorite,
            width: width, height: height,
            onFavoriteToggle: onFavoriteToggle
        )
        
        let hostingController = UIHostingController(rootView: bookCellView)
        
        if let view = hostingController.view {
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
            
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: contentView.topAnchor),
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
            
            self.hostingController = hostingController
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hostingController?.view.removeFromSuperview()
        hostingController = nil
        onFavoriteToggle = nil
    }
}


