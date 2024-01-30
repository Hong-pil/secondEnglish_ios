//
//  ApiControl+LoginSNS.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/30/24.
//

import Foundation
import Moya
import Combine
import CombineMoya

extension ApiControl {
    
    static func addSnsUser(loginId: String, loginType: String) -> AnyPublisher<LoginSuccessResponse, ErrorModel> {
        Future<LoginSuccessResponse, ErrorModel> { promise in
            
            let apis: ApisLoginSNS = .addSnsUser(
                login_id: loginId,
                login_type: loginType
            )
            
            // call
            let provider = MoyaProvider<ApisLoginSNS>()
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
