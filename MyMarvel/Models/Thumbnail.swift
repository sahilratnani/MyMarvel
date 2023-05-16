//
//  Thumbnail.swift
//  MyMarvel
//
//  Created by Sahil Ratnani on 08/05/23.
//

import Foundation
import RealmSwift
class Thumbnail: Object, Codable {
    ///The directory path of to the image.
    @Persisted var path: String?
    ///The file extension for the image.
    @Persisted var `extension`: String?

    var url: String? {
        guard let path = path, let ext = `extension` else { return nil }
        return "\(path)/standard_medium.\(ext)"
    }

    enum CodingKeys: String, CodingKey {
        case path = "path"
        case `extension` = "extension"
    }
}
