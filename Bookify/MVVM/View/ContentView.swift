//
//  ContentView.swift
//  Bookify
//
//  Created by Ami Intwala on 22/03/24.
//

import SwiftUI

// MARK: - Content View
struct ContentView: View {
    @ObservedObject var viewModel: BookListViewModel
    @State private var active: Bool = false

    init() {
        let apiManager = APIManager()
        self.viewModel = BookListViewModel(apiManager: apiManager)
    }

    var body: some View {
        NavigationView {
            List(viewModel.apps, id: \.id) { book in
                NavigationLink(destination: DetailView(book: book), isActive: $active) {
                    HStack {
                        if #available(iOS 15.0, *) {
                            AsyncImage(url: URL(string: book.artworkUrl100))
                                .scaledToFit()
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text(book.artistName)
                                .font(.title2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(book.name)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Release Date:")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(book.releaseDate)
                                .font(.subheadline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 5.0)
                           }
                       }
                   }
               }.accessibilityIdentifier("booksList")
                .navigationBarTitle(!active ? "Books" : "", displayMode: .large)
        }
    }
}

//MARK: - Detail View -
struct DetailView: View {
    var book: BookListModel

    var body: some View {
        VStack {
            if #available(iOS 15.0, *) {
                AsyncImage(url: URL(string: book.artworkUrl100))
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            Text(book.name)
                .font(.title)
                .frame(alignment: .center)
            Text("By \(book.artistName)")
                .font(.headline)
                .padding()
            Text("Release Date: \(book.releaseDate)")
                .font(.subheadline)
            if let url = URL(string: book.url) {
                Link("\(book.url)", destination: url)
                    .font(.body)
                    .padding(.horizontal, 10)
            }
            Spacer()
        }
        .navigationBarTitleDisplayMode(.large)
    }
}
//end
