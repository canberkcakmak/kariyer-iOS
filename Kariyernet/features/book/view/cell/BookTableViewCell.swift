//
//  BookTableViewCell.swift
//  Kariyernet
//
//  Created by Canberk Çakmak on 14.02.2025.
//

import UIKit
import SwiftUI

class BookTableViewCell: UITableViewCell {
    static let reuseIdentifier = "BookTableViewCell"
    
    private var hostingController: UIHostingController<BookRowView>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        selectionStyle = .none
        contentView.backgroundColor = .clear
    }
    
    func configure(with book: Book) {
        hostingController?.view.removeFromSuperview()
        hostingController = nil
        
        let bookRowView = BookRowView(book: book)
        let newHostingController = UIHostingController(rootView: bookRowView)
        
        newHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(newHostingController.view)

        NSLayoutConstraint.activate([
            newHostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            newHostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            newHostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            newHostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        hostingController = newHostingController
    }


    
    override func prepareForReuse() {
        super.prepareForReuse()
        hostingController?.view.removeFromSuperview()
        hostingController = nil
    }
}
