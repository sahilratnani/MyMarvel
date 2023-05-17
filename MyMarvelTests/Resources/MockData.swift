//
//  MockData.swift
//  MyMarvelTests
//
//  Created by Sahil Ratnani on 17/05/23.
//

import Foundation
@testable import MyMarvel

enum MockData {
    static var mockCharacters: [Character] {
        let json = TestUtils.readJSONFromFile(fileName: "CharactersResponseJson")
        guard let results = json?["data"] as? [String: Any], let charactersData = results["results"] else {
            return []
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: charactersData)
            return try JSONDecoder().decode([Character].self, from: data )
        } catch {
            assertionFailure("Error in reading charcters - \(error)")
            return []
        }
    }
}
