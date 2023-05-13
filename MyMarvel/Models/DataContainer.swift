//
//  DataContainer.swift
//  MyMarvel
//
//  Created by Sahil Ratnani on 13/05/23.
//

import Foundation

class DataContainer<T: Codable>: Codable {
    ///The requested offset (number of skipped results) of the call.
    var offset: Int?
    ///The requested result limit.
    var limit: Int?
    ///The total number of resources available given the current filter set.
    var total: Int?
    ///The total number of results returned by this call.
    var count: Int?
    ///The list of Object T returned by the call.
    var results: [T] = []

    enum CodinKeys: String, CodingKey {
        case offset = "offset"
        case limit = "limit"
        case total = "total"
        case count = "count"
        case results = "results"
    }
}
