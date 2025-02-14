//
//  BookAsyncImage.swift
//  Kariyernet
//
//  Created by Canberk Çakmak on 14.02.2025.
//

import SwiftUI

struct BookAsyncImage: View {
    let url: String
    let height: CGFloat
    let width: CGFloat?
    let contentMode: ContentMode
    
    private var placeholderImage: some View {
        Image(systemName: "book.fill")
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .clipped()
            .foregroundColor(.gray)
    }
    
    init(
        url: String,
        height: CGFloat,
        width: CGFloat? = nil,
        contentMode: ContentMode = .fill
    ) {
        self.url = url
        self.height = height
        self.width = width
        self.contentMode = contentMode
    }
    
    var body: some View {
          if let _ = URL(string: url),
             let cachedImage = ImageCache.shared.get(for: url) {
              Image(uiImage: cachedImage)
                  .resizable()
                  .scaledToFill()
                  .frame(width: width, height: height)
                  .clipped()
          } else if let validURL = URL(string: url) {
              AsyncImage(url: validURL) { phase in
                  switch phase {
                  case .empty:
                      ProgressView()
                          .frame(width: width, height: height)
                  case .success(let image):
                      image
                          .resizable()
                          .scaledToFill()
                          .frame(width: width, height: height)
                          .clipped()
                          .onAppear {
                              if let uiImage = ImageRenderer(content:
                                  image
                                      .resizable()
                                      .scaledToFill()
                                      .frame(width: width ?? 300, height: height)
                                      .clipped()
                              ).uiImage {
                                  ImageCache.shared.set(uiImage, for: url)
                              }
                          }
                  case .failure:
                      placeholderImage
                  @unknown default:
                      EmptyView()
                  }
              }
          } else {
              placeholderImage
          }
      }
  }


#Preview {
    BookAsyncImage(
        url: "https://picsum.photos/200/300",
        height: 200,
        width: 150
    )
}
