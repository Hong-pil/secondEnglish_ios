//
//  RefreshManager.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import Combine

class RefreshManager: ObservableObject {
    static let shared = RefreshManager()
    
    var homeRefreshSubject = PassthroughSubject<(), Never>()
    var postChangeDataSubject = PassthroughSubject<(PostChanged), Never>()
}



struct PostChanged {
    enum State {
        case Create(code: String?)
        case Update
        case Delete(postId: String)
    }
    
    let state: State
//    var clubPost: ClubDetailModel? = nil
//    var comPost: CommunityDetailModel? = nil
}
