//
//  Book.swift
//  Kariyernet
//
//  Created by Canberk Çakmak on 6.02.2025.
//

import Foundation

struct Book: Codable {
    let artistName: String
    let id: String
    let name: String
    let releaseDate: String
    let kind: String
    let artistId: String
    let artistUrl: String
    let artworkUrl100: String
    let url: String
    let contentAdvisoryRating: String?
}

extension Book {
    static var sampleBook: Book {
        Book(
            artistName: "Canberk Çakmak",
            id: "123",
            name: "Example Book",
            releaseDate: "2024-02-06",
            kind: "books",
            artistId: "123",
            artistUrl: "https://google.com",
            artworkUrl100: "https://picsum.photos/200/300",
            url: "https://google.com",
            contentAdvisoryRating: nil
        )
    }
    static var sampleBook2: Book {
        Book(
            artistName: "Example Book",
            id: "321",
            name: "Harry Poter",
            releaseDate: "2024-02-07",
            kind: "books",
            artistId: "321",
            artistUrl: "https://google.com",
            artworkUrl100: "https://picsum.photos/200/300",
            url: "https://google.com",
            contentAdvisoryRating: nil
        )
    }
}
