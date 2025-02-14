//
//  BookRowView.swift
//  Kariyernet
//
//  Created by Canberk Çakmak on 14.02.2025.
//

import SwiftUI

struct BookRowView: View {
    let book: Book
    
    var body: some View {
        HStack(spacing: 12) {
            
            BookAsyncImage(
                url: book.artworkUrl100, height: 90,
                contentMode: .fit
            ).frame(width: 60, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(book.name)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                Text(book.artistName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text(book.releaseDate)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 110)
        .padding(.horizontal, 8)
    }
}

#Preview {
    BookRowView(
        book: .sampleBook
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}
