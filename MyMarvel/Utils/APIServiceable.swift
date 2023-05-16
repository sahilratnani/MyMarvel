//
//  APIServiceable.swift
//  MyMarvel
//
//  Created by Sahil Ratnani on 15/05/23.
//

import Foundation

typealias APIResult = (Result<[Character], Error>) -> Void

//An API Service protocol that as of now has method to fetch characters list.
protocol APIServiceable {
    func getAllCharacters(offset: Int?, limit: Int?, completion: @escaping APIResult)
}
