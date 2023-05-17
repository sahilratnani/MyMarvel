//
//  TestUtils.swift
//  MyMarvelTests
//
//  Created by Sahil Ratnani on 17/05/23.
//

import Foundation

class TestUtils {
    static func readJSONFromFile(fileName: String) -> [String : Any]? {
        var json: [String : Any]?
        if let path = Bundle(for: self.self).path(forResource: fileName, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                json = try? JSONSerialization.jsonObject(with: data) as? [String : Any]
            } catch {
                assertionFailure("Failed to read json file - \(fileName)")
            }
        }
        return json
    }
}
