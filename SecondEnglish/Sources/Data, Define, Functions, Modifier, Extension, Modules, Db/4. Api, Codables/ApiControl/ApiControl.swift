//
//  ApiControl.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import Moya
import Combine
import CombineMoya

struct ApiControl {
    static var canclelables = Set<AnyCancellable>()
    
    static func mconfig(serviceType: String) -> AnyPublisher<MconfigData, ErrorModel> {
        Future<MconfigData, ErrorModel> { promise in
            
            let apis: Apis = .Mconfig(deviceType: "ios", serviceType: serviceType)
            let provider = MoyaProvider<Apis>()
            provider.requestPublisher(apis)
                .sink(receiveCompletion: { completion in
                    guard case let .failure(error) = completion else { return }
                    fLog(error)
                    promise(.failure(ErrorModel(code: "error")))
                }, receiveValue: { response in
                    
                    jsonLog(data: response.data, systemCode: response.statusCode)
                    
                    let result = try? JSONDecoder().decode(MconfigData.self, from: response.data)
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
    
    
    //MARK: - Log
    static func jsonLog(data:Data, systemCode:Int, functionName:String = #function, isLogOn:Bool = false) {
        if isLogOn {
            fLog("\n--- Response Code : \(systemCode) (\(functionName)) ------------------------------------------------------------------------------\n\(String(data: data, encoding: .utf8) ?? "None")\n------------------------------------------------------------------------------\n")
        }
    }
}
