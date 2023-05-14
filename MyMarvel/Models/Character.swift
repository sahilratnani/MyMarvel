//
//  Character.swift
//  MyMarvel
//
//  Created by Sahil Ratnani on 07/05/23.
//

import Foundation

class Character: Codable {
    /// The unique ID of the character resource
    var id: Int?
    /// The name of the character
    var name: String?
    ///A short bio or description of the character
    var description : String?
    ///The representative image for this character.
    var thumbnail: Thumbnail?
    ///The canonical URL identifier for this resource.
    var resourceURI: String?
    ///The flag if character is bookmarked
    lazy var bookmarked = false

    enum CodinKeys: String, Codable {
        case id = "id"
        case name = "name"
        case description = "description"
        case thumbnail = "thumbnail"
        case resourceURI = "resourceURI"
    }
}
