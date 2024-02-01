//
//  ApiControl+Swipe.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import Moya
import Combine
import CombineMoya

extension ApiControl {
    static func getSwipeCategory() -> AnyPublisher<SwipeCategory, ErrorModel> {
        Future<SwipeCategory, ErrorModel> { promise in
            
            let apis: ApisSwipe = .swipeCategory
            
            //call
            let provider = MoyaProvider<ApisSwipe>()
            provider.requestPublisher(apis)
                .sink(receiveCompletion: { completion in
                    guard case let .failure(error) = completion else { return }
                    fLog(error)
                    promise(.failure(ErrorModel(code: "error")))
                }, receiveValue: { response in
                    
                    jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                    
                    //error check start --------------------------------------------------------------------------------
                    if ErrorHandler.checkAuthError(code: response.statusCode) {
                        return
                    }
                    
                    if response.statusCode != 200 {
                        let result = try? JSONDecoder().decode(ErrorModel.self, from: response.data)
                        if result != nil {
                            promise(.failure(result!))
                        }
                        else {
                            promise(.failure(ErrorModel(code: "error")))
                        }
                        
                        return
                    }
                    //error check end --------------------------------------------------------------------------------
                    
                    let result = try? JSONDecoder().decode(SwipeCategory.self, from: response.data)
                    if result != nil {
                        promise(.success(result!))
                    }
                    else {
                        promise(.failure(ErrorModel(code: "error")))
                    }
                })
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
    
    static func getSwipeList(isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<SwipeDataResponse, ErrorModel> {
        Future<SwipeDataResponse, ErrorModel> { promise in
            
            let apis: ApisSwipe = .swipeList
            
            //call
            let provider = MoyaProvider<ApisSwipe>()
            provider.requestPublisher(apis)
                .sink(receiveCompletion: { completion in
                    guard case let .failure(error) = completion else { return }
                    //fLog("error : \(error)")
                    promise(.failure(ErrorModel(code: "error")))
                    
                    switch ErrorHandler.checkToken(
                        statusCode: error.response?.statusCode,
                        data: error.response?.data) {
                    case .WrongRequestToken:
                        fLog("idpil::: 잘못된 토큰인 경우")
                    case .ExpiredAccessToken:
                        fLog("idpil::: AccessToken 만료된 경우")
                        
                        // 원래는 로그아웃 하면 안 되고, accesstoken 다시 발급받고, 이 api 호출 다시 해야됨.
                        PopupManager.dismissAll()
                        UserManager.shared.logout()
                        
                        
                        
                    case .ExpiredRefreshToken:
                        fLog("idpil::: RefreshToken 만료된 경우")
                    }
                    
                    isExpiredAccessToken()
                }, receiveValue: { response in
                    jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                    
                    //error check start --------------------------------------------------------------------------------
                    if ErrorHandler.checkAuthError(code: response.statusCode) {
                        return
                    }
                    
                    if response.statusCode != 200 {
                        let result = try? JSONDecoder().decode(ErrorModel.self, from: response.data)
                        if result != nil {
                            promise(.failure(result!))
                        }
                        else {
                            promise(.failure(ErrorModel(code: "error")))
                        }
                        
                        return
                    }
                    //error check end --------------------------------------------------------------------------------
                    
                    let result = try? JSONDecoder().decode(SwipeDataResponse.self, from: response.data)
                    if result != nil {
                        promise(.success(result!))
                    }
                    else {
                        promise(.failure(ErrorModel(code: "error")))
                    }
                })
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
    
    static func likeCard(uid: String, cardIdx: Int, isLike: Int, isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<LikeCardResponse, ErrorModel> {
        Future<LikeCardResponse, ErrorModel> { promise in
            
            let apis: ApisSwipe = .likeCard(uid: uid, cardIdx: cardIdx, isLike: isLike)
            
            //call
            let provider = MoyaProvider<ApisSwipe>()
            provider.requestPublisher(apis)
                .sink(receiveCompletion: { completion in
                    guard case let .failure(error) = completion else { return }
                    //fLog("error : \(error)")
                    promise(.failure(ErrorModel(code: "error")))
                    
                    switch ErrorHandler.checkToken(
                        statusCode: error.response?.statusCode,
                        data: error.response?.data) {
                    case .WrongRequestToken:
                        fLog("idpil::: 잘못된 토큰인 경우")
                    case .ExpiredAccessToken:
                        fLog("idpil::: AccessToken 만료된 경우")
                        
                        // 원래는 로그아웃 하면 안 되고, accesstoken 다시 발급받고, 이 api 호출 다시 해야됨.
                        PopupManager.dismissAll()
                        UserManager.shared.logout()
                        
                        
                        
                    case .ExpiredRefreshToken:
                        fLog("idpil::: RefreshToken 만료된 경우")
                    }
                    
                    isExpiredAccessToken()
                }, receiveValue: { response in
                    jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                    
                    //error check start --------------------------------------------------------------------------------
                    if ErrorHandler.checkAuthError(code: response.statusCode) {
                        return
                    }
                    
                    if response.statusCode != 200 {
                        let result = try? JSONDecoder().decode(ErrorModel.self, from: response.data)
                        if result != nil {
                            promise(.failure(result!))
                        }
                        else {
                            promise(.failure(ErrorModel(code: "error")))
                        }
                        
                        return
                    }
                    //error check end --------------------------------------------------------------------------------
                    
                    let result = try? JSONDecoder().decode(LikeCardResponse.self, from: response.data)
                    if result != nil {
                        promise(.success(result!))
                    }
                    else {
                        promise(.failure(ErrorModel(code: "error")))
                    }
                })
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
    
    static func getMyLikeCardList(uid: String, isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<MyLikeCardResponse, ErrorModel> {
        Future<MyLikeCardResponse, ErrorModel> { promise in
            
            let apis: ApisSwipe = .myLikeCardList(uid: uid)
            
            //call
            let provider = MoyaProvider<ApisSwipe>()
            provider.requestPublisher(apis)
                .sink(receiveCompletion: { completion in
                    guard case let .failure(error) = completion else { return }
                    //fLog("error : \(error)")
                    promise(.failure(ErrorModel(code: "error")))
                    
                    switch ErrorHandler.checkToken(
                        statusCode: error.response?.statusCode,
                        data: error.response?.data) {
                    case .WrongRequestToken:
                        fLog("idpil::: 잘못된 토큰인 경우")
                    case .ExpiredAccessToken:
                        fLog("idpil::: AccessToken 만료된 경우")
                        
                        // 원래는 로그아웃 하면 안 되고, accesstoken 다시 발급받고, 이 api 호출 다시 해야됨.
                        PopupManager.dismissAll()
                        UserManager.shared.logout()
                        
                        
                        
                    case .ExpiredRefreshToken:
                        fLog("idpil::: RefreshToken 만료된 경우")
                    }
                    
                    isExpiredAccessToken()
                }, receiveValue: { response in
                    jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                    
//                    //error check start --------------------------------------------------------------------------------
//                    if ErrorHandler.checkAuthError(code: response.statusCode) {
//                        return
//                    }
//                    
//                    if response.statusCode != 200 {
//                        let result = try? JSONDecoder().decode(ErrorModel.self, from: response.data)
//                        if result != nil {
//                            promise(.failure(result!))
//                        }
//                        else {
//                            promise(.failure(ErrorModel(code: "error")))
//                        }
//                        
//                        return
//                    }
//                    //error check end --------------------------------------------------------------------------------
                    
                    let result = try? JSONDecoder().decode(MyLikeCardResponse.self, from: response.data)
                    if result != nil {
                        promise(.success(result!))
                    }
                    else {
                        promise(.failure(ErrorModel(code: "error")))
                    }
                })
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
    
}
