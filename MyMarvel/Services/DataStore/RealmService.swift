//
//  RealmService.swift
//  MyMarvel
//
//  Created by Sahil Ratnani on 16/05/23.
//

import Foundation
import RealmSwift

final class RealmService: RealmServiceable {
    static var defaultInstance = RealmService(configuration: defaultConfig)
    
    private static var defaultConfig: Realm.Configuration {
        let username = "MyMarvel"
        var config = Realm.Configuration.defaultConfiguration
        config.fileURL!.deleteLastPathComponent()
        config.fileURL!.appendPathComponent(username)
        config.fileURL!.appendPathExtension("realm")
        return config
    }

    var realm: Realm

    init(configuration: Realm.Configuration) {
        do {
            realm = try Realm(configuration: configuration)
        } catch {
            fatalError("Could not open realm - \(error)")
        }
    }

    func getData<T: Object>(of type: T.Type) -> Results<T>{
        let results = realm.objects(type)
        return results
    }

    func writeData(object: Object, updatePolicy: Realm.UpdatePolicy = .error) {
        do {
            try realm.write {
                realm.add(object, update: updatePolicy)
            }
        }
        catch{
            print("Something went wrong")
        }
    }

    func writeData(objects: [Object], updatePolicy: Realm.UpdatePolicy = .error) {
        do {
            try realm.write {
                realm.add(objects, update: updatePolicy)
            }
        }
        catch{
            print("Something went wrong")
        }
    }

    func update<T: Object>(_ object: T, operation: @escaping (T) -> Void) {
        do {
            try realm.write {
                operation(object)
            }
        }
        catch{
            print("Something went wrong")
        }
    }
}
