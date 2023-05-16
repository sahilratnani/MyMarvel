//
//  Character.swift
//  MyMarvel
//
//  Created by Sahil Ratnani on 07/05/23.
//

import Foundation
import RealmSwift

class Character: Object, Codable {
    /// The unique ID of the character resource
    @Persisted(primaryKey: true) var id: Int?
    /// The name of the character
    @Persisted var name: String?
    ///A short bio or description of the character
    @Persisted var desc : String?
    ///The representative image for this character.
    @Persisted var thumbnail: Thumbnail?
    ///The canonical URL identifier for this resource.
    @Persisted var resourceURI: String?
    ///The flag if character is bookmarked
    @Persisted var bookmarked = false

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case desc = "description"
        case thumbnail = "thumbnail"
        case resourceURI = "resourceURI"
    }
}
