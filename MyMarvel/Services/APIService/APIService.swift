//
//  APIService.swift
//  MyMarvel
//
//  Created by Sahil Ratnani on 08/05/23.
//

import Foundation
class APIService {
    private enum ApiURL {
        case db
        case base

        var baseURL: String {
            switch self {
            case .db: return "http://gateway.marvel.com/v1/public"
            case .base: return "http://gateway.marvel.com"
            }
        }
    }

    private enum Endpoint {
        case characterList

        var path: String {
            switch self {
            case .characterList: return "/characters"
            }
        }

        var url: String {
            switch self {
            case .characterList: return "\(ApiURL.db.baseURL)\(path)"
            }
        }

    }

    static func getAllCharacters(completion: @escaping (Result<[Character], Error>) -> Void) {
        guard Reachability.isConnectedToNetwork(),
              let url = URL(string: Endpoint.characterList.url) else {
                  completion(.failure(CustomError.noConnection))
                  return
              }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(#function, "🧨 Request: \(request)\nError: \(error)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(CustomError.noData))
                return
            }

            do {
                let data = try JSONDecoder().decode(DataWrapper<Character>.self, from: data)
                completion(.success(data.results))
            } catch let error {
                print(#function, "🧨 Request: \(request)\nError: \(error)")
                completion(.failure(error))
            }

        }.resume()

    }
}
