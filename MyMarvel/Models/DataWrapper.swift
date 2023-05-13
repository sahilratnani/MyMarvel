//
//  DataWrapper.swift
//  MyMarvel
//
//  Created by Sahil Ratnani on 07/05/23.
//

import Foundation

class DataWrapper<T: Codable>: Codable {
    ///The requested offset (number of skipped results) of the call.
    var code: Int?
    ///The requested result limit.
    var status: String?
    ///The list of Object T returned by the call.
    var data: DataContainer<T>?

    enum CodinKeys: String, CodingKey {
        case code = "code"
        case status = "status"
        case data = "data"
    }
}
