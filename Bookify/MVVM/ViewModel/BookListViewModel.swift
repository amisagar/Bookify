//
//  BookListViewModel.swift
//  Bookify
//
//  Created by Ami Intwala on 22/03/24.
//

import Foundation
import Combine

class BookListViewModel: ObservableObject {

    @Published var apps: [BookListModel] = []
    private var cancellables = Set<AnyCancellable>()
    var apiManager: APIManager

    init(apiManager: APIManager) {
        self.apiManager = apiManager
        fetchBookList()
    }

    func fetchBookList() {
        apiManager.getData(endpoint: urlPath, type: MainResponse.self)
            .sink { completion in
                switch completion {
                    case .failure(let err):
                        print("Error is \(err.localizedDescription)")
                    case .finished:
                        print("Finished")
                    }
            } receiveValue: { [weak self] appResponse in
                guard let uSelf = self else {
                    return
                }
                uSelf.apps = appResponse.feed.results
            } .store(in: &cancellables)
    }
}
//end
