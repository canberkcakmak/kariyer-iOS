//
//  BookCellView.swift
//  Kariyernet
//
//  Created by Canberk Çakmak on 6.02.2025.
//

import SwiftUI

struct BookCellView: View {
    let book: Book
    let isFavorite: Bool
    let width: CGFloat
    let height: CGFloat
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 8) {
                BookAsyncImage(
                          url: book.artworkUrl100,
                          height: height,
                          width: width,
                          contentMode: .fill
                      )
                      .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Text(book.name)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                Text(book.artistName)
                    .font(.system(size: 12, weight: .medium))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .padding(8)
            
            Button(action: onFavoriteToggle) {
                Image(systemName: "star.fill")
                    .foregroundColor(isFavorite ? .yellow : .gray)
                    .padding(8)
                    .background(Circle()
                        .fill(.white)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2))
            }
            .padding(16)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    BookCellView(
        book: .sampleBook,
        isFavorite: true,
        width: 180, height: 240,
        onFavoriteToggle: {}
    )
}
