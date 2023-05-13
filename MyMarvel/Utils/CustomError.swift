//
//  CustomError.swift
//  MyMarvel
//
//  Created by Sahil Ratnani on 13/05/23.
//

import Foundation

enum CustomError {
    case noConnection, noData
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noData: return "Well, weird thing happens"
        case .noConnection: return "No Internet Connection"
        }
    }
}
