//
//  BookListModel.swift
//  Bookify
//
//  Created by Ami Intwala on 22/03/24.
//

import Foundation

// MARK: - Main Response
struct MainResponse: Codable {
    let feed: Feed
}

// MARK: - Feed
struct Feed: Codable {
    let title: String
    let id: String
    let author: Author
    let copyright: String
    let icon: String
    let updated: String
    let results: [BookListModel]
}

// MARK: - Result
public struct BookListModel: Codable, Identifiable {
    let artistName: String
    public let id: String
    let name: String
    let releaseDate: String
    let artworkUrl100: String
    let url: String
    let genres: [Genres]
}

// MARK: - Genres
struct Genres: Codable {
    let genreId: String
    let name: String
    let url: String
}

// MARK: - Author
struct Author: Codable {
    let name: String
    let url: String
}
