//
//  Feed.swift
//  Kariyernet
//
//  Created by Canberk Çakmak on 06.02.2025.
//

import Foundation

struct BooksResponse: Codable {
    let feed: Feed
}

struct Feed: Codable {
    let title: String
    let id: String
    let copyright: String
    let country: String
    let icon: String
    let updated: String
    let results: [Book]
}
