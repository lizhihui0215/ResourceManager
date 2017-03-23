//
//  RMNetworkServices.swift
//  ResourceManager
//
//  Created by 李智慧 on 23/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import Foundation
import Moya

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}

let RMNetworkServicesProvider = RxMoyaProvider<RMNetworkServices>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])


public enum RMNetworkServices {
    case login(String, String)
}

extension RMNetworkServices: TargetType {
    public var baseURL: URL {
        return URL(string: "http://localhost:8080/api/test")!
    }
    
    public var path: String {
        return ""
    }
    
    public var method: Moya.Method {
        switch self {
        case .login( _ , _):
            return .post
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .login(let username, let password):
            return ["username" : username,
                    "password" : password]
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    public var sampleData: Data {
        return "Half measures are as bad as nothing at all.".utf8Encoded
    }
    
    public var task: Task {
        return .request
    }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}






