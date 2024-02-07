//
//  ApiControl+LoginJoin.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import Moya
import Combine
import CombineMoya

extension ApiControl {
    
    static func sendSMS(toPhoneNumber: String, accountSid: String, authToken: String, fromPhoneNumber: String) -> AnyPublisher<LoginJoinDataResponse, ErrorModel> {
        Future<LoginJoinDataResponse, ErrorModel> { promise in
            
            let apis: ApisLoginJoin = .send_sms(
                toPhoneNumber: toPhoneNumber,
                accountSid: accountSid,
                authToken: authToken,
                fromPhoneNumber: fromPhoneNumber
            )
            
            // call
            let provider = MoyaProvider<ApisLoginJoin>()
            provider.requestPublisher(apis)
                .sink(
                    receiveCompletion: { completion in
                        
                        guard case let .failure(error) = completion else { return }
                        fLog(error)
                        promise(.failure(ErrorModel(code: "error")))

                    },
                    receiveValue: { response in
                        
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        // error check start
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
                        //error check end
                        
                        let result = try? JSONDecoder().decode(LoginJoinDataResponse.self, from: response.data)
                        
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
    
    static func verifySmsCode(toPhoneNumber: String, code: String, login_type: String, deviceUUID: String) -> AnyPublisher<LoginSuccessResponse, ErrorModel> {
        Future<LoginSuccessResponse, ErrorModel> { promise in
            
            let apis: ApisLoginJoin = .verify_sms_code(
                toPhoneNumber: toPhoneNumber,
                code: code,
                login_type: login_type,
                deviceUUID: deviceUUID
            )
            
            // call
            let provider = MoyaProvider<ApisLoginJoin>()
            provider.requestPublisher(apis)
                .sink(
                    receiveCompletion: { completion in
                        
                        guard case let .failure(error) = completion else { return }
                        fLog(error)
                        promise(.failure(ErrorModel(code: "error")))

                    },
                    receiveValue: { response in
                        
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        // error check start
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
                        //error check end
                        
                        let result = try? JSONDecoder().decode(LoginSuccessResponse.self, from: response.data)
                        
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
