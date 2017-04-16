//
//  RMNetworkServices.swift
//  ResourceManager
//
//  Created by 李智慧 on 23/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import Foundation
import Moya
import Result
import RxSwift
import RealmSwift
import ObjectMapper


private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}


//let commonEndpointClosure = { (target: Target) -> Endpoint<Target> in
//    var URL = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString
//
//    let endpoint = Endpoint<Target>(URL: URL,
//                                    sampleResponseClosure: {.NetworkResponse(200, target.sampleData)},
//                                    method: target.method,
//                                    parameters: target.parameters)
//
//    // 添加 AccessToken
//    if let accessToken = currentUser.accessToken {
//        return endpoint.endpointByAddingHTTPHeaderFields(["access-token": accessToken])
//    } else {
//        return endpoint
//    }
//}




let RMNetworkServicesProvider = RxMoyaProvider<RMNetworkAPI>(endpointClosure: {target in
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    
    let endpoint = Endpoint<RMNetworkAPI>(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        parameters: target.parameters,
        parameterEncoding: target.parameterEncoding
    )
    
    switch target {
    case .inspectUpload:
        
        let _ = endpoint.adding(newHTTPHeaderFields: ["accept" : "application/json"])
        
    default: break;
    }
    
    
    return endpoint
},plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])



class RMNetworkServices {
    static let shared = RMNetworkServices()
    static var kMessage : String = ""
    static var kCode : String = ""
    static var kResults : String = ""
    
    func config(messageKey: String? = "message",
                codeKey: String? = "code",
                resultsKey: String? = "results")  {
        RMNetworkServices.kMessage = messageKey!
        RMNetworkServices.kCode = codeKey!
        RMNetworkServices.kResults = resultsKey!
    }
    
    func request<T>(_ token: RMNetworkAPI) -> Observable<RMResponseObject<T>> {
        
        
        return RMNetworkServicesProvider.request(token).mapObject(RMResponseObject<T>.self)
    }
    
    func request<T>(_ token: RMNetworkAPI) -> Observable<RMResponseArray<T>> {
        return RMNetworkServicesProvider.request(token).mapObject(RMResponseArray<T>.self)
    }
}

public enum RMNetworkAPI {
    case login(String, String)
    case linkDetail(String, String)
    case linkList(String, String, String, String, Int, Int)
    case linkModify(String,[String : Any])
    case inspectUpload(String, [String: Any], [MultipartFormData])
    case cabinetList(String, String, String, String, Int, Int)
    case cabinetDetail(String, String)
    case inspectList(String,Int, Int)
    
}


extension RMNetworkAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "http://115.28.157.117:9080/resourcemanage/iosapi")!
    }
    
    public var path: String {
        switch self {
        case .login(_, _):
            return "login"
        case let .linkDetail(accessToken,_):
            return "link/query?access_token=\(accessToken)"
        case let .linkList(accessToken,_,_,_,_,_):
            return "link/fuzzyquery?access_token=\(accessToken)"
        case let .cabinetDetail(accessToken,_):
            return "cabinet/query?access_token=\(accessToken)"
        case let .cabinetList(accessToken,_,_,_,_,_):
            return "cabinet/fuzzyquery?access_token=\(accessToken)"
        case let .inspectList(accessToken,_,_):
            return "inspect/query?access_token=\(accessToken)"
        case let .linkModify(accessToken,_):
            return "link/modify?access_token=\(accessToken)"
        case let .inspectUpload(accessToken,_,_):
            return "inspect/report?access_token=\(accessToken)"
        }
        
    }
    
    public var method: Moya.Method {
        switch self {
        case .login,
             .linkDetail,
             .linkList,
             .cabinetDetail,
             .cabinetList,
             .inspectList,
             .linkModify,
             .inspectUpload:
            return .post
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case let .login(username, password):
            return ["username" : username,
                    "password" : password,
                    "osType": 1,
                    "osVersion" : device.systemVersion,
                    "appVersion" : device.appVersion,
                    "devicetoken": device.uuid]
        case let .linkDetail(_, linkCode):
            return ["linkCode": linkCode]
        case let .linkList(_,account, customerName, linkCode, pageNO, pageSize):
            return ["account": account,
                    "customerName": customerName,
                    "linkCode": linkCode,
                    "pageSize": pageSize,
                    "pageNO": pageNO]
        case let .cabinetDetail(_, linkCode):
            return ["cabinetCode": linkCode]
        case let .cabinetList(_,account, customerName, linkCode, pageNO, pageSize):
            return ["account": account,
                    "customerName": customerName,
                    "cabinetCode": linkCode,
                    "pageSize": pageSize,
                    "pageNO": pageNO]
        case let .inspectList(_,pageNO, pageSize):
            return ["pageSize": pageSize,
                    "pageNO": pageNO]
        case let .linkModify(_, link):
            var parameter = link
            parameter["accessDeviceUpTime"] = Date().description
            return parameter
        case let .inspectUpload(_, parameters, _):
            let json = parameters.toJSONString()
            return ["json" : json! ]
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        
        switch self {
        case .login,
             .linkDetail,
             .linkList,
             .cabinetDetail,
             .cabinetList,
             .inspectList,
             .inspectUpload,
             .linkModify:
            return JSONEncoding.default
        }
    }
    
    public var sampleData: Data {
        return "Half measures are as bad as nothing at all.".utf8Encoded
    }
    
    public var task: Task {
        switch self {
        case .login,
             .linkDetail,
             .linkList,
             .cabinetDetail,
             .cabinetList,
             .inspectList,
             .linkModify:
            return .request
        case let .inspectUpload(_,_, formData):
            return .upload(.multipart(formData))
            
        }
    }
}

extension Dictionary {
    func toJSONString() -> String? {
        
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            return String(data: data, encoding: String.Encoding.utf8)
        }
        return nil
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
