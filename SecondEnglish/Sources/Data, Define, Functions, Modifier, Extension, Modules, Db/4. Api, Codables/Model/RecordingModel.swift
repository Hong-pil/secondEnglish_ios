//
//  RecordingModel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation

public struct Recording: Hashable {
    public let uid: UUID
    public var fileURL: URL
    public var cardID: String
    
    public init(fileURL: URL, cardID: String) {
        uid = UUID()
        self.fileURL = fileURL
        self.cardID = cardID
    }
}

public struct SampleModel: Hashable {
    let id: UUID
    let sample: Float
    
    init(sample: Float) {
        self.id = UUID()
        self.sample = sample
    }
}

struct RecordingSampleModel: Hashable {
    let id: UUID
    var sample: Int
    
    init(sample: Int) {
        self.id = UUID()
        self.sample = sample
    }
}
