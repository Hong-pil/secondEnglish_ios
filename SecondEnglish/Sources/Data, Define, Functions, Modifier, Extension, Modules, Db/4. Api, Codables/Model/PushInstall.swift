//
//  PushInstall.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/19/24.
//

import Foundation

struct PushInstall: Codable {
    let appId: String
    let countryCode: String
    var device: String = "ios"
    let fcmToken: String
    let integUid: String
    let langCode: String
    let lastLoginAt: String
    let usePush: Bool
}


struct AlimMessageCode: Codable {
    let alimMessageMap: AlimMessageMap?
    let mapSize: Int?
}

struct AlimMessageMap: Codable, Hashable {
    let additionalProp1: [AlimAdditionalProp]?
    let additionalProp2: [AlimAdditionalProp]?
    let additionalProp3: [AlimAdditionalProp]?
}

struct AlimAdditionalProp: Codable, Hashable {
    var alimLinkCode: String? = nil
    var alimMessageCode: String? = nil
    var createDate: String? = nil
    var description: String? = nil
    var langCode: String? = nil
    var serviceType: String? = nil
    var text01: String? = nil
    var text02: String? = nil
    var text03: String? = nil
    var updateDate: String? = nil
}

struct AlimUserMessage: Codable {
      let alimList: [AlimMessage]?
      let listSize: Int?
      let nextId: String?
}

struct AlimUnreadMessage: Codable {
      let alimResList: [AlimMessage]?
      let count: Int?
}

struct AlimMessage: Codable, Hashable {
    let alimId: Int?
    let createDate: String?
    let link: String?
    let image: String?
    let status: Int?
    let text01: String?
    let text02: String?
    let text03: String?
}
