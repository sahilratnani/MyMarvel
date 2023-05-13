//
//  Thumbnail.swift
//  MyMarvel
//
//  Created by Sahil Ratnani on 08/05/23.
//

import Foundation
class Thumbnail: Codable {
    ///The directory path of to the image.
    var path: String?
    ///The file extension for the image.
    var `extension`: String?

    var url: String? {
        guard let path = path, let ext = `extension` else { return nil }
        return "\(path)/standard_medium.\(ext)"
    }

    enum CodinKeys: String, CodingKey {
        case path = "path"
        case `extension` = "extension"
    }
}
