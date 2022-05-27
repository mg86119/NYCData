//
//  NetworkingService.swift
//  NYCData
//
//  Created by Murali krishna Gajula on 5/26/22.
//

import Foundation

/// Custom error type to handle all network errors
enum NYCDataError: Error {
    case JsonError
    case InvalidURL
    case Unknown
}

/// Generic networking class
/// As of now, It only handles Response but we can similarily add `RequestT`
class Networking<ResponseT>: NSObject where ResponseT: Codable {

    typealias Handler = (Result<ResponseT, NYCDataError>) -> Void
    private var task: URLSessionDataTask?

    func makeNetworkCall(urlString: String, completion: @escaping Handler) {
        guard task == nil else {
            completion(.failure(.Unknown))
            return
        }

        guard let url = URL(string: urlString) else {
            completion(.failure(.InvalidURL))
            return
        }

        task = URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.Unknown))
                }
                return
            }

            guard let schools = try? JSONDecoder().decode(ResponseT.self, from: data) else {
                DispatchQueue.main.async {
                    completion(.failure(.JsonError))
                }
                return
            }

            DispatchQueue.main.async {
                completion(.success(schools))
            }
        }
        task?.resume()
    }
}
