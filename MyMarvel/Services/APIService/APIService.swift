//
//  APIService.swift
//  MyMarvel
//
//  Created by Sahil Ratnani on 08/05/23.
//

import Foundation
import CommonCrypto

class APIService {
    private enum ApiURL {
        case db
        case base

        var publicKey: String {
            "9ce1f403c52d5d0643eebc7f43eeaf66"
        }
        var privateKey: String {
            "d5226b3043b633187aaf9924ca292502147bf61a"
        }
        var baseURL: String {
            switch self {
            case .db: return "https://gateway.marvel.com:443/v1/public"
            case .base: return "https://gateway.marvel.com"
            }
        }

        func URL(path: String ) -> String {
            let ts = NSDate().timeIntervalSince1970.description
            let md5 = MD5(string: ts+privateKey+publicKey)
            return "\(ApiURL.db.baseURL)\(path)?ts=\(ts)&apikey=\(publicKey)&hash=\(md5)"
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
            case .characterList: return ApiURL.db.URL(path: path)
            }
        }

    }

    static func getAllCharacters(offset: Int? = nil, limit: Int? = nil, completion: @escaping (Result<[Character], Error>) -> Void) {
        guard Reachability.isConnectedToNetwork(),
              var url = URL(string: Endpoint.characterList.url) else {
                  completion(.failure(CustomError.noConnection))
                  return
              }
        var queryItems: [URLQueryItem] = []
        if let limit = limit {
            queryItems.append(URLQueryItem(name: "limit", value: limit.description))
        }
        if let offset = offset {
            queryItems.append(URLQueryItem(name: "offset", value: offset.description))
        }
        url.append(queryItems: queryItems)

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
                completion(.success(data.data?.results ?? []))
            } catch let error {
                print(#function, "🧨 Request: \(request)\nError: \(error)")
                completion(.failure(error))
            }

        }.resume()

    }
}
