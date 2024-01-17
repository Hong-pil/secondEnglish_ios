//
//  Profile.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/17/24.
//

import Foundation

struct Profile: Identifiable, Equatable {
    //var id: Int = UUID().uuidString.hash
    var id: Int
    let name: String
    let age: String
    let location: String?
    let distanceKilometers: Int?
    let isVerified: Bool
    let images: [String]
}

extension Profile {
    static let gorby = Profile(id: 0, name: "Gorby", age: "8", location: "Seattle, Washington", distanceKilometers: 7821, isVerified: true, images: ["gorby"])
    static let grumpy = Profile(id: 1, name: "Grumpy", age: "7", location: "Morristown, Arizona", distanceKilometers: 8675, isVerified: true, images: ["grumpy"])
    static let keyboard = Profile(id: 2, name: "Keyboard Cat", age: "17", location: nil, distanceKilometers: nil, isVerified: true, images: ["keyboard"])
    static let maru = Profile(id: 3, name: "Maru", age: "15", location: "Japan", distanceKilometers: 9282, isVerified: true, images: ["maru"])
    static let sockington = Profile(id: 4, name: "Sockington", age: "18", location: "Waltham, Massachusetts", distanceKilometers: nil, isVerified: true, images: ["sockington"])
    static let joep = Profile(id: 4, name: "Joep", age: "3", location: "Leiden, Netherlands", distanceKilometers: 15, isVerified: false, images: ["joep"])

    static let all: [Profile] = [.maru, .sockington, .gorby, .grumpy, .keyboard, .joep]
}
