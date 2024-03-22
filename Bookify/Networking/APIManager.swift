//
//  APIManager.swift
//  Bookify
//
//  Created by Ami Intwala on 22/03/24.
//

import Foundation
import Combine

//MARK: - Network Error -
enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "")
        }
    }
}

//MARK: - APIManager class -
class APIManager: NSObject {

    static let shared = APIManager()
    private var cancellables = Set<AnyCancellable>()

     func getData<T: Decodable>(endpoint: String, id: Int? = nil, type: T.Type) -> AnyPublisher<T, Error> {
        return Future<T, Error> { [weak self] promise in  
            guard let self = self, let url = URL(string: endpoint) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: {  data in
                    print(data)
                    promise(.success(data))
                })
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher() 
    }
}
//end
