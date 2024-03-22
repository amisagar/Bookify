//
//  BookifyTests.swift
//  BookifyTests
//
//  Created by Ami Intwala on 22/03/24.
//

import XCTest
import Combine
import SwiftUI
@testable import Bookify

class BookifyTests: XCTestCase {

    // Mock APIManager to simulate network requests
    class MockAPIManager: APIManager {
        override func getData<T: Decodable>(endpoint: String, id: Int?, type: T.Type) -> AnyPublisher<T, Error> {
            // Create mock response data here
            let mockResponse = MainResponse(feed: Feed(title: "Top Books", id: "101", author: Author(name: "Apple", url: "https://www.apple.com/"), copyright: "Copyright © 2024 Apple Inc. All rights reserved.", icon: "https://www.apple.com/favicon.ico", updated: "Fri, 22 Mar 2024 16:04:45 +0000", results: [BookListModel(artistName: "Jill Shalvis", id: "201", name: "The Family You Make", releaseDate: "2022-01-11", artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Publication126/v4/7e/14/d6/7e14d66c-24ac-2f7e-4bbc-6f423290b3b0/9781472284433.jpg/100x153bb.png", url: "https://books.apple.com/gb/book/the-family-you-make/id1569764575", genres: [Genres(genreId: "1", name: "Romance", url: "https://itunes.apple.com/gb/genre/id9003"), Genres(genreId: "2", name: "Fiction & Literature", url: "https://itunes.apple.com/gb/genre/id9031")]), BookListModel(artistName: "Tracy Cooper-Posey", id: "202", name: "His Parisian Mistress", releaseDate: "2020-01-07", artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Publication123/v4/d3/2d/05/d32d055c-8e71-d8af-c86a-5f98a0a42bf5/HisParisianMistress_eReader-1.jpg/100x150bb.png", url: "https://books.apple.com/gb/book/his-parisian-mistress/id1493877380", genres: [Genres(genreId: "1001", name: "Historical Romance", url: "https://itunes.apple.com/gb/genre/id10059"), Genres(genreId: "25", name: "Historical Fiction", url: "https://itunes.apple.com/gb/genre/id10047")])]))

            // Simulate async operation by wrapping mockResponse in a Future
            return Future<T, Error> { promise in
                    promise(.success(mockResponse as! T))
            }.eraseToAnyPublisher()
        }
    }

    // Mock APIManager to simulate network requests with error
    class MockAPIManagerError: APIManager {
        override func getData<T: Decodable>(endpoint: String, id: Int? = nil, type: T.Type) -> AnyPublisher<T, Error> {
            // Simulate error scenario
            return Future<T, Error> { promise in
                promise(.failure(NetworkError.invalidURL))
            }.eraseToAnyPublisher()
        }
    }

    // Test fetchBookList success case
    func testFetchBookListSuccess() {
        let mockAPIManager = MockAPIManager()
        let viewModel = BookListViewModel(apiManager: mockAPIManager)
        viewModel.apiManager = mockAPIManager
        let expectation = XCTestExpectation(description: "Fetch books successfully")
        viewModel.fetchBookList()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Adjust delay as needed
            XCTAssertFalse(viewModel.apps.isEmpty)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5) // Adjust timeout as needed
    }

    // Test fetchBookList failure case
    func testFetchBookListFailure() {
        let mockAPIManager = MockAPIManagerError()
        let viewModel = BookListViewModel(apiManager: mockAPIManager)
        viewModel.apiManager = mockAPIManager
        let expectation = XCTestExpectation(description: "Fetch books failure")
        viewModel.fetchBookList()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Adjust delay as needed
            // Check if apps array is empty or not
            XCTAssert(viewModel.apps.isEmpty)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5) // Adjust timeout as needed
    }
}
