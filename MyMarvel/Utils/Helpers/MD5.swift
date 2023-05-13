//
//  MD5.swift
//  MyMarvel
//
//  Created by Sahil Ratnani on 13/05/23.
//

import Foundation
import CryptoKit

func MD5(string: String) -> String {
    let digest = Insecure.MD5.hash(data: Data(string.utf8))

    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}
