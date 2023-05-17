//
//  RealmServiceTests.swift
//  MyMarvelTests
//
//  Created by Sahil Ratnani on 17/05/23.
//

import XCTest
import Pods_MyMarvel
import RealmSwift
import Foundation
@testable import MyMarvel

class RealmServiceTests: XCTestCase {
    var sut: RealmService!
    var testRealmConfig: Realm.Configuration {
        var config = Realm.Configuration.defaultConfiguration
        config.inMemoryIdentifier = self.name
        return config
    }
    override func setUpWithError() throws {
        sut = RealmService(configuration: testRealmConfig)
    }

    override func tearDownWithError() throws {
        sut.realm.deleteAll()
        sut = nil
    }

    func testRealmCreation() {
        XCTAssertEqual(sut.realm.configuration.inMemoryIdentifier, testRealmConfig.inMemoryIdentifier)
        XCTAssertNotEqual(sut.realm.configuration.inMemoryIdentifier, Realm.Configuration.defaultConfiguration.inMemoryIdentifier)
    }

    func testGetData() {
        let mockData = MockData.mockCharacters
        addDataToRealm(data: mockData)
        let dataFromRealm = sut.getData(of: Character.self)
        XCTAssertEqual(dataFromRealm.count, mockData.count)
        XCTAssertEqual(mockData.first?.id, dataFromRealm.first?.id)
        XCTAssertEqual(mockData.first?.name, dataFromRealm.first?.name)
    }

    func testWriteData_singleObject() {
        guard let mockData = MockData.mockCharacters.first else {
            XCTFail("could not get mock data")
            return
        }
        mockData.id = 123123
        sut.writeData(object: mockData)
        let dataFromRealm = getObjectFromRealm(matching: mockData)
        XCTAssertEqual(dataFromRealm.count, 1)
        XCTAssertEqual(dataFromRealm.first, mockData)
        XCTAssertEqual(dataFromRealm.first?.id, mockData.id)
    }

    func testWriteData_multipleObjects() {
        let mockData = MockData.mockCharacters
        sut.writeData(objects: mockData)

        let dataFromRealm = getPersistedData()
        
        XCTAssertNotNil(dataFromRealm)
        XCTAssertEqual(dataFromRealm.count, mockData.count)
        XCTAssertEqual(dataFromRealm.first?.id, mockData.first?.id)
    }

    func testUpdate() {
        let newName = "Sahil"
        guard let mockData = MockData.mockCharacters.first else {
            XCTFail("could not get mock data")
            return
        }
        addDataToRealm(data: [mockData])
        let dataFromRealm = getObjectFromRealm(matching: mockData).first!
       let expectation = XCTestExpectation(description: "testUpdate")
        sut.update(dataFromRealm) { object in
            object.name = newName
            expectation.fulfill()
        }
        XCTAssertEqual(dataFromRealm.name, newName)
    }
}

extension RealmServiceTests {
    func addDataToRealm(data: [Character], function: StaticString = #function, line: UInt  = #line) {
        sut.writeData(objects: data)
    }

    func getObjectFromRealm(matching data: Character, function: StaticString = #function, line: UInt  = #line) -> [Character] {
        let result = sut.getData(of: Character.self).filter { $0.id == data.id }
        return result.map { $0 } as [Character]
    }

    func getPersistedData() -> [Character] {
        sut.getData(of: Character.self).map { $0 } as [Character]
    }
}
