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
    
    static func getSwipeSubCategory(type2: String) -> AnyPublisher<SwipeCategory, ErrorModel> {
        Future<SwipeCategory, ErrorModel> { promise in
            
            let apis: ApisSwipe = .swipeSubCategory(type2: type2)
            
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
    
    // 현재 서브 카테고리의 영문 리스트 조회 (회원용)
    static func getSwipeListByCategory(main_category: String, type3_sort_num: Int, isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<SwipeDataResponse, ErrorModel> {
        Future<SwipeDataResponse, ErrorModel> { promise in
            
            let apis: ApisSwipe = .swipeListByCategory(main_category: main_category, type3_sort_num: type3_sort_num)
            
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
    
    // 현재 서브 카테고리의 영문 리스트 조회 (게스트용)
    static func getSwipeListByCategoryForGuest(main_category: String, type3_sort_num: Int) -> AnyPublisher<SwipeDataResponse, ErrorModel> {
        Future<SwipeDataResponse, ErrorModel> { promise in
            
            let apis: ApisSwipe = .swipeListByCategoryForGuest(main_category: main_category, type3_sort_num: type3_sort_num)
            
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
    
    static func getGuestCategoryProgress() -> AnyPublisher<MyLearningProgressResponse, ErrorModel> {
        Future<MyLearningProgressResponse, ErrorModel> { promise in
            
            let apis: ApisSwipe = .guestCategoryProgress
            
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
    
    static func getMyLikeCardList(isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<MyCardResponse, ErrorModel> {
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
                    let apis: ApisSwipe = .myLikeCardList
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
                                
                                // 원래는 로그아웃 하면 안 되고, accesstoken 다시 발급받고, 이 api 호출 다시 해야됨.
                                PopupManager.dismissAll()
                                UserManager.shared.logout()
                                
                            case .ExpiredAccessToken:
                                fLog("idpil::: AccessToken 만료된 경우")
                                
                                // 원래는 로그아웃 하면 안 되고, accesstoken 다시 발급받고, 이 api 호출 다시 해야됨.
                                PopupManager.dismissAll()
                                UserManager.shared.logout()
                                
                                
                                
                            case .ExpiredRefreshToken:
                                fLog("idpil::: RefreshToken 만료된 경우")
                                
                                PopupManager.dismissAll()
                                UserManager.shared.logout()
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
    
    static func getMyPostCardList(isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<MyCardResponse, ErrorModel> {
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
                    let apis: ApisSwipe = .myPostCardList
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
                                
                                // 원래는 로그아웃 하면 안 되고, accesstoken 다시 발급받고, 이 api 호출 다시 해야됨.
                                PopupManager.dismissAll()
                                UserManager.shared.logout()
                                
                            case .ExpiredAccessToken:
                                fLog("idpil::: AccessToken 만료된 경우")
                                
                                // 원래는 로그아웃 하면 안 되고, accesstoken 다시 발급받고, 이 api 호출 다시 해야됨.
                                PopupManager.dismissAll()
                                UserManager.shared.logout()
                                
                                
                                
                            case .ExpiredRefreshToken:
                                fLog("idpil::: RefreshToken 만료된 경우")
                                
                                PopupManager.dismissAll()
                                UserManager.shared.logout()
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
    
    static func addCardList(type1: String, type2: String, type3: String, type2_sort_num: Int, type3_sort_num: Int, sentence_list: [Dictionary<String, String>], isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<LikeCardResponse, ErrorModel> {
        Future<LikeCardResponse, ErrorModel> { promise in
            
            let apis: ApisSwipe = .addCardList(type1: type1, type2: type2, type3: type3, type2_sort_num: type2_sort_num, type3_sort_num: type3_sort_num, sentence_list: sentence_list)
            
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
    
    static func doBlockCard(cardIdx: Int, isBlock: String, isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<ReportCardResponse, ErrorModel> {
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
    
    static func doBlockUser(targetUid: String, targetNickname: String, isBlock: String, isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<ReportCardResponse, ErrorModel> {
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
    
    static func editCard(idx: Int, korean: String, english: String, isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<ReportCardResponse, ErrorModel> {
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
                    let apis: ApisSwipe = .editCard(idx: idx, korean: korean, english: english)
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
    
    static func deleteCard(idx: Int, isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<ReportCardResponse, ErrorModel> {
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
                    let apis: ApisSwipe = .deleteCard(idx: idx)
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
    
    static func knowCard(targetCardMainCategory: String, targetCardSubCategory: String, targetCardIdx: Int, isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<ReportCardResponse, ErrorModel> {
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
                    let apis: ApisSwipe = .knowCard(targetCardMainCategory: targetCardMainCategory, targetCardSubCategory: targetCardSubCategory, targetCardIdx: targetCardIdx)
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
    
    static func readKnowCard(targetCardMainCategory: String, isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<KnowCardResponse, ErrorModel> {
        Future<KnowCardResponse, ErrorModel> { promise in
            
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
                    let apis: ApisSwipe = .readKnowCard(targetCardMainCategory: targetCardMainCategory)
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
                            
                            let result = try? JSONDecoder().decode(KnowCardResponse.self, from: response.data)
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
    
    static func readMyAllCategories(mainCategory: String, isExpiredAccessToken: @escaping()->Void={}) -> AnyPublisher<MyAllMainCategoryResponse, ErrorModel> {
        Future<MyAllMainCategoryResponse, ErrorModel> { promise in
            
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
                    let apis: ApisSwipe = .readMyAllCategories(mainCategory: mainCategory)
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
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
    
    
    
    static func readGuestAllCategories(mainCategory: String) -> AnyPublisher<MyAllMainCategoryResponse, ErrorModel> {
        Future<MyAllMainCategoryResponse, ErrorModel> { promise in
            
            let apis: ApisSwipe = .readGuestAllCategories(mainCategory: mainCategory)
            
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
    
}

