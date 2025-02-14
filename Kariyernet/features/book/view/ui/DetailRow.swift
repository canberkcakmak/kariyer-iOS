//
//  DetailRow.swift
//  Kariyernet
//
//  Created by Canberk Çakmak on 14.02.2025.
//

import SwiftUI

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.body)
        }
    }
}
#Preview {
    VStack(alignment: .leading, spacing: 20) {
        DetailRow(
            title: "Author",
            value: "Test"
        )
        
        DetailRow(
            title: "Published Date",
            value: "January 1, 2024"
        )
        
        DetailRow(
            title: "Pages",
            value: "256"
        )
    }
    .padding()
}
