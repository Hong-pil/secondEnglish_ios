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
    
    static func getSwipeMainCategory() -> AnyPublisher<SwipeCategory, ErrorModel> {
        Future<SwipeCategory, ErrorModel> { promise in
            
            let apis: ApisSwipe = .swipeMainCategory
            
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
    
    
    static func getSwipeCategory(category: String) -> AnyPublisher<SwipeCategory, ErrorModel> {
        Future<SwipeCategory, ErrorModel> { promise in
            
            let apis: ApisSwipe = .swipeCategory(category: category)
            
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
    
    static func getSwipeListByCategory(main_category: String, sub_category: String, isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<SwipeDataResponse, ErrorModel> {
        Future<SwipeDataResponse, ErrorModel> { promise in
            
            let apis: ApisSwipe = .swipeListByCategory(main_category: main_category, sub_category: sub_category)
            
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
    
    static func getMyCategoryProgress(isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<MyLearningProgressResponse, ErrorModel> {
        Future<MyLearningProgressResponse, ErrorModel> { promise in
            
            let apis: ApisSwipe = .myCategoryProgress
            
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
                    
                    let result = try? JSONDecoder().decode(MyLearningProgressResponse.self, from: response.data)
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
    
    static func likeCard(cardIdx: Int, isLike: Int, isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<LikeCardResponse, ErrorModel> {
        Future<LikeCardResponse, ErrorModel> { promise in
            
            let apis: ApisSwipe = .likeCard(cardIdx: cardIdx, isLike: isLike)
            
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
    
    
    static func getMyCardList(isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<MyCardResponse, ErrorModel> {
        Future<MyCardResponse, ErrorModel> { promise in
            
            // 토큰 로직 완성해야됨
            Authenticator.shared.validToken()
                .sink { completion in
                    guard case let .failure(error) = completion else { return }
                    fLog(error)
                    
                    if let err = error as? AuthenticationError {
                        switch err {
                        case .networkDisconnected:
                            /**
                             * 여기 호출은 되는데.. 팝업 왜 안 뜸..??
                             */
                            DispatchQueue.main.async {
                                StatusManager.shared.stopAllLoading()
                                AlertManager().showAlertNetworkDisconnected()
                            }
                        case .loginRequired(let request, let data):
                            DispatchQueue.main.async {
                                StatusManager.shared.stopAllLoading()
                                AlertManager().showAlertAuthError()
                            }
                        }
                    }
                } receiveValue: { token in
                    let apis: ApisSwipe = .myCardList
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
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
    
    static func addCardList(type1: String, type2: String, type3: String, sentence_list: [Dictionary<String, String>], isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<LikeCardResponse, ErrorModel> {
        Future<LikeCardResponse, ErrorModel> { promise in
            
            let apis: ApisSwipe = .addCardList(type1: type1, type2: type2, type3: type3, sentence_list: sentence_list)
            
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

    
    static func getReportList(isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<ReportListResponse, ErrorModel> {
        Future<ReportListResponse, ErrorModel> { promise in
            
            // 토큰 로직 완성해야됨
            Authenticator.shared.validToken()
                .sink { completion in
                    guard case let .failure(error) = completion else { return }
                    fLog(error)
                    
                    if let err = error as? AuthenticationError {
                        switch err {
                        case .networkDisconnected:
                            /**
                             * 여기 호출은 되는데.. 팝업 왜 안 뜸..??
                             */
                            DispatchQueue.main.async {
                                StatusManager.shared.stopAllLoading()
                                AlertManager().showAlertNetworkDisconnected()
                            }
                        case .loginRequired(let request, let data):
                            DispatchQueue.main.async {
                                StatusManager.shared.stopAllLoading()
                                AlertManager().showAlertAuthError()
                            }
                        }
                    }
                } receiveValue: { token in
                    let apis: ApisSwipe = .getReportList
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
                            
                            let result = try? JSONDecoder().decode(ReportListResponse.self, from: response.data)
                            if result != nil {
                                promise(.success(result!))
                            }
                            else {
                                promise(.failure(ErrorModel(code: "error")))
                            }
                        })
                        .store(in: &canclelables)
                }
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
    
    static func doReportCard(targetUid: String, targetCardIdx: Int, reportCode: Int, isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<ReportCardResponse, ErrorModel> {
        Future<ReportCardResponse, ErrorModel> { promise in
            
            // 토큰 로직 완성해야됨
            Authenticator.shared.validToken()
                .sink { completion in
                    guard case let .failure(error) = completion else { return }
                    fLog(error)
                    
                    if let err = error as? AuthenticationError {
                        switch err {
                        case .networkDisconnected:
                            /**
                             * 여기 호출은 되는데.. 팝업 왜 안 뜸..??
                             */
                            DispatchQueue.main.async {
                                StatusManager.shared.stopAllLoading()
                                AlertManager().showAlertNetworkDisconnected()
                            }
                        case .loginRequired(let request, let data):
                            DispatchQueue.main.async {
                                StatusManager.shared.stopAllLoading()
                                AlertManager().showAlertAuthError()
                            }
                        }
                    }
                } receiveValue: { token in
                    let apis: ApisSwipe = .doReportCard(
                        targetUid: targetUid,
                        targetCardIdx: targetCardIdx,
                        reportCode: reportCode
                    )
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
                            
                            let result = try? JSONDecoder().decode(ReportCardResponse.self, from: response.data)
                            if result != nil {
                                promise(.success(result!))
                            }
                            else {
                                promise(.failure(ErrorModel(code: "error")))
                            }
                        })
                        .store(in: &canclelables)
                }
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
    
    static func doBlockCard(cardIdx: Int, isBlock: Int, isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<ReportCardResponse, ErrorModel> {
        Future<ReportCardResponse, ErrorModel> { promise in
            
            // 토큰 로직 완성해야됨
            Authenticator.shared.validToken()
                .sink { completion in
                    guard case let .failure(error) = completion else { return }
                    fLog(error)
                    
                    if let err = error as? AuthenticationError {
                        switch err {
                        case .networkDisconnected:
                            /**
                             * 여기 호출은 되는데.. 팝업 왜 안 뜸..??
                             */
                            DispatchQueue.main.async {
                                StatusManager.shared.stopAllLoading()
                                AlertManager().showAlertNetworkDisconnected()
                            }
                        case .loginRequired(let request, let data):
                            DispatchQueue.main.async {
                                StatusManager.shared.stopAllLoading()
                                AlertManager().showAlertAuthError()
                            }
                        }
                    }
                } receiveValue: { token in
                    let apis: ApisSwipe = .doBlockCard(
                        cardIdx: cardIdx,
                        isBlock: isBlock
                    )
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
                            
                            let result = try? JSONDecoder().decode(ReportCardResponse.self, from: response.data)
                            if result != nil {
                                promise(.success(result!))
                            }
                            else {
                                promise(.failure(ErrorModel(code: "error")))
                            }
                        })
                        .store(in: &canclelables)
                }
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
    
    static func doBlockUser(targetUid: String, targetNickname: String, isBlock: Bool, isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<ReportCardResponse, ErrorModel> {
        Future<ReportCardResponse, ErrorModel> { promise in
            
            // 토큰 로직 완성해야됨
            Authenticator.shared.validToken()
                .sink { completion in
                    guard case let .failure(error) = completion else { return }
                    fLog(error)
                    
                    if let err = error as? AuthenticationError {
                        switch err {
                        case .networkDisconnected:
                            /**
                             * 여기 호출은 되는데.. 팝업 왜 안 뜸..??
                             */
                            DispatchQueue.main.async {
                                StatusManager.shared.stopAllLoading()
                                AlertManager().showAlertNetworkDisconnected()
                            }
                        case .loginRequired(let request, let data):
                            DispatchQueue.main.async {
                                StatusManager.shared.stopAllLoading()
                                AlertManager().showAlertAuthError()
                            }
                        }
                    }
                } receiveValue: { token in
                    let apis: ApisSwipe = .doBlockUser(
                        targetUid: targetUid,
                        targetNickname: targetNickname,
                        isBlock: isBlock
                    )
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
                            
                            let result = try? JSONDecoder().decode(ReportCardResponse.self, from: response.data)
                            if result != nil {
                                promise(.success(result!))
                            }
                            else {
                                promise(.failure(ErrorModel(code: "error")))
                            }
                        })
                        .store(in: &canclelables)
                }
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
}

