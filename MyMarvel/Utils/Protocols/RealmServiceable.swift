//
//  RealmServiceable.swift
//  MyMarvel
//
//  Created by Sahil Ratnani on 16/05/23.
//

import Foundation
import RealmSwift

protocol RealmServiceable {
    var realm: Realm { get }
    ///Fetch data of Type T from realm DB. Returns Results of provided class type
    func getData<T: Object>(of type: T.Type) -> Results<T>
    ///write to realm DB
    func writeData(object: Object, updatePolicy: Realm.UpdatePolicy)
    ///write collection of objects to realm DB
    func writeData(objects: [Object], updatePolicy: Realm.UpdatePolicy)
    ///Update existing record in Realm DB
    func update<T: Object>(_ object: T, operation: @escaping (T) -> Void)
}
