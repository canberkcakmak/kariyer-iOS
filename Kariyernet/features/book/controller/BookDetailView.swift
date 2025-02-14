//
//  BookDetailView.swift
//  Kariyernet
//
//  Created by Canberk Çakmak on 6.02.2025.
//

import SwiftUI

struct BookDetailView: View {
    let book: Book
    @State private var isBookFavorite: Bool
    let onFavoriteToggle: () -> Void
    
    init(book: Book, isFavorite: Bool, onFavoriteToggle: @escaping () -> Void) {
        self.book = book
        self._isBookFavorite = State(initialValue: isFavorite)
        self.onFavoriteToggle = onFavoriteToggle
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                BookAsyncImage(
                    url: book.artworkUrl100,
                    height: 400
                )
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(book.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(book.artistName)
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    DetailRow(title: "Yayın Tarihi", value: DateHelper.formatDate(book.releaseDate))
                    DetailRow(title: "Tür", value: book.kind)
                    
                    if let rating = book.contentAdvisoryRating {
                        DetailRow(title: "İçerik Derecelendirmesi", value: rating)
                    }
                    
                    BookLink(
                        title: "Yazar Profili",
                        url: book.artistUrl,
                        topPadding: 8
                    )
                    
                    BookLink(
                        title: "Kitap Sayfası",
                        url: book.url,
                        topPadding: 8
                    )
                }
                .padding(.horizontal)
            }
        }
        .navigationBarItems(trailing: Button(action: {
            isBookFavorite.toggle()
            onFavoriteToggle()
        }) {
            Image(systemName: "star.fill")
                .foregroundColor(isBookFavorite ? .yellow : .gray)
                .font(.title2)
        })
        .navigationTitle("Detay")
        .navigationBarTitleDisplayMode(.inline)
    }}

#Preview {
    NavigationView {
        BookDetailView(
            book: .sampleBook,
            isFavorite: true,
            onFavoriteToggle: {}
        )
    }
}
