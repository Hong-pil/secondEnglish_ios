//
//  ApiControl+Menu.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/21/24.
//

import Foundation
import Moya
import Combine
import CombineMoya

extension ApiControl {
    
    static func getMySentence() -> AnyPublisher<MyAllMainCategoryResponse, ErrorModel> {
        Future<MyAllMainCategoryResponse, ErrorModel> { promise in
            
            let apis: ApisMenu = .mySentence
            
            //call
            let provider = MoyaProvider<ApisMenu>()
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
                    
                    let result = try? JSONDecoder().decode(MyAllMainCategoryResponse.self, from: response.data)
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
    
    static func getMyPostLike() -> AnyPublisher<MenuResponse, ErrorModel> {
        Future<MenuResponse, ErrorModel> { promise in
            
            let apis: ApisMenu = .likePost
            
            //call
            let provider = MoyaProvider<ApisMenu>()
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
                    
                    let result = try? JSONDecoder().decode(MenuResponse.self, from: response.data)
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
    
    static func getMyGetLike() -> AnyPublisher<MenuResponse, ErrorModel> {
        Future<MenuResponse, ErrorModel> { promise in
            
            let apis: ApisMenu = .likeGet
            
            //call
            let provider = MoyaProvider<ApisMenu>()
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
                    
                    let result = try? JSONDecoder().decode(MenuResponse.self, from: response.data)
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
    
    static func getCardBlock() -> AnyPublisher<MyCardResponse, ErrorModel> {
        Future<MyCardResponse, ErrorModel> { promise in
            
            let apis: ApisMenu = .cardBlock
            
            //call
            let provider = MoyaProvider<ApisMenu>()
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
                    
                    let result = try? JSONDecoder().decode(MyCardResponse.self, from: response.data)
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
    
    static func getUserBlock() -> AnyPublisher<UserBlockResponse, ErrorModel> {
        Future<UserBlockResponse, ErrorModel> { promise in
            
            let apis: ApisMenu = .userBlock
            
            //call
            let provider = MoyaProvider<ApisMenu>()
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
                    
                    let result = try? JSONDecoder().decode(UserBlockResponse.self, from: response.data)
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
    
    static func getPopularCardTop10(isWeek: Bool) -> AnyPublisher<PopularCardTop10Response, ErrorModel> {
        Future<PopularCardTop10Response, ErrorModel> { promise in
            
            let apis: ApisMenu = .popularCardTop10(isWeek: isWeek)
            
            //call
            let provider = MoyaProvider<ApisMenu>()
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
                    
                    let result = try? JSONDecoder().decode(PopularCardTop10Response.self, from: response.data)
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
    
    
    static func editCardList(sentence_list: [Dictionary<String, String>], isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<LikeCardResponse, ErrorModel> {
        Future<LikeCardResponse, ErrorModel> { promise in
            
            let apis: ApisMenu = .editCardList(sentence_list: sentence_list)
            
            //call
            let provider = MoyaProvider<ApisMenu>()
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
    
    
}
