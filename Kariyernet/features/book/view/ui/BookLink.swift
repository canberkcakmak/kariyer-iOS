//
//  BookLink.swift
//  Kariyernet
//
//  Created by Canberk Çakmak on 14.02.2025.
//

import SwiftUI

struct BookLink: View {
    let title: String
    let url: String
    let topPadding: CGFloat
    
    init(title: String, url: String, topPadding: CGFloat = 4) {
        self.title = title
        self.url = url
        self.topPadding = topPadding
    }
    
    var body: some View {
        if let url = URL(string: url) {
            Link(title, destination: url)
                .font(.headline)
                .foregroundColor(.blue)
                .padding(.top, topPadding)
        }
    }
}
#Preview {
    VStack(alignment: .leading) {
        BookLink(
            title: "Swift Programming",
            url: "https://www.apple.com/swift/",
            topPadding: 4
        )
        
        BookLink(
            title: "SwiftUI Tutorial",
            url: "https://developer.apple.com/tutorials/swiftui",
            topPadding: 8
        )
    }
    .padding()
}
