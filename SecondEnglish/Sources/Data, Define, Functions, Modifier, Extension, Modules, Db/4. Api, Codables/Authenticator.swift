//
//  Authenticator.swift
//  SecondEnglish
//
//  Created by kimhongpil on 2/21/24.
//

import Foundation
import Combine

class Authenticator {
    static let shared = Authenticator()
    
    private let queue = DispatchQueue(label: "Autenticator.\(UUID().uuidString)")
    
    private var currentToken: DataObj?
    private var refreshPublisher: AnyPublisher<DataObj, Error>?
    
    func validToken(forceRefresh: Bool = false) -> AnyPublisher<DataObj, Error> {
        if !UserManager.shared.accessToken.isEmpty {
            currentToken = DataObj(access_token: UserManager.shared.account)
        }
        return queue.sync { [weak self] in
            
            // 먼저 네트워크 상태 확인
            if NetworkMonitorManager.shared.isConnected.value == false {
                // 인터넷 연결 안 된 경우
                return Fail(error: AuthenticationError.networkDisconnected)
                    .eraseToAnyPublisher()
            }
            
            
            
            
            /**
             * 일단 이렇게 두고, 팬투 코드보면서 코드 마무리할 것.
             */
            return Just(DataObj())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}

enum AuthenticationError: Error {
    case networkDisconnected
    case loginRequired(request: URLRequest? = nil, data: ErrorModel? = nil)
}
