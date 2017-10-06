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
import PCCWFoundationSwift

public enum RMAPITarget {
    case login(String, String)
    case linkDetail(String, String)
    case linkList(String, String, String, String, Int, Int)
    case link(String, String)
    case linkModify(String,[String : Any])
    case cabinetModify(String, [String : Any])
    case deviceModify(String, [String : Any])
    case inspectUpload(String, [String: Any], [MultipartFormData])
    case cabinetList(String, String, String, String, Int, Int)
    case deviceList(String, String, String, Int, Int)
    case cabinetDetail(String, String)
    case deviceDetail(String, String)
    case ports(String, String)
    case inspectList(String,Int, Int)
    case exchangePassword(String, String, String)
    case suggest(String, String, String, String)
    case portLinks(String, String)
}

extension RMAPITarget: PFSTargetType {
    public var headers: [String : String]? {
        return [:]
    }
    
    static var kBaseURL: String {
        get {
            guard let baseURL: String = RMDataRepository.shared.cache(key: "BaseURL") else {
                return "http://115.28.157.117:9080"
            }
            return baseURL
        }
        set {
            RMDataRepository.shared.cache(key: "BaseURL", value: newValue)
        }
    }
    
    public var baseURL: URL {
        let urlString = RMAPITarget.kBaseURL.appending("/resourcemanage/iosapi")
        return URL(string: urlString)!
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
        case let .exchangePassword(accessToken,_,_):
            return "user/changepwd?access_token=\(accessToken)"
        case let .suggest(accessToken,_,_,_):
            return "user/feedback?access_token=\(accessToken)"
        case let .link(accessToken,_):
            return "device/links?access_token=\(accessToken)"
        case let .deviceList(accessToken,_,_,_,_):
            return "device/fuzzyquery?access_token=\(accessToken)"
        case let .deviceDetail(accessToken,_):
            return "device/query?access_token=\(accessToken)"
        case let .ports(accessToken, _):
            return "device/ports?access_token=\(accessToken)"
        case let .cabinetModify(accessToken, _):
            return "cabinet/modify?access_token=\(accessToken)"
        case let .deviceModify(accessToken, _):
            return "device/modify?access_token=\(accessToken)"
        case let .portLinks(accessToken, _) :
            return "device/portlinks?access_token=\(accessToken)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login, .linkDetail, .linkList, .cabinetDetail, .cabinetList,
             .inspectList, .linkModify, .exchangePassword,
             .suggest, .link, .deviceList, .deviceDetail, .ports,
             .cabinetModify, .deviceModify, .inspectUpload, .portLinks:
            return .post
        }
    }
    
    public var sampleData: Data {
        return "Half measures are as bad as nothing at all.".utf8Encoded
    }
    
    public var task: Task {
        var parameters: [String: Any] = [:]
        switch self {
        case let .login(username, password):
            parameters = ["username" : username,
                          "password" : password,
                          "osType": 1,
                          "osVersion" : device.systemVersion,
                          "appVersion" : device.appVersion,
                          "devicetoken": device.uuid]
        case let .linkDetail(_, linkCode):
            parameters = ["linkId": linkCode]
        case let .linkList(_,account, customerName, linkCode, pageNO, pageSize):
            parameters = ["linkName": account,
                          "customerName": customerName,
                          "linkCode": linkCode,
                          "pageSize": pageSize,
                          "pageNO": pageNO]
        case let .cabinetDetail(_, cabinetId):
            parameters = ["cabinetId": cabinetId]
        case let .cabinetList(_,cabinetCode, _, _, pageNO, pageSize):
            parameters = ["cabinetCode": cabinetCode,
                          "pageSize": pageSize,
                          "pageNO": pageNO]
        case let .inspectList(_,pageNO, pageSize):
            parameters = ["pageSize": pageSize,
                          "pageNO": pageNO]
        case let .linkModify(_, link):
            var parameter = link
            parameter["accessDeviceUpTime"] = Date().description
            parameters = parameter
        case let .exchangePassword(_, oldpwd, newpwd):
            parameters = ["oldpwd": oldpwd,
                          "newpwd": newpwd]
        case let .suggest(_, name, phone,detail):
            parameters = ["name": name,
                          "phone": phone,
                          "detail": detail]
        case let .link(_, deviceCode):
            parameters = ["deviceCode": deviceCode]
        case let .deviceList(_,_, deviceCode,pageNO, pageSize):
            parameters = ["deviceCode": deviceCode,
                          "pageSize": pageSize,
                          "pageNO": pageNO]
        case let .deviceDetail(_,deviceCode):
            parameters = ["deviceCode": deviceCode]
        case let .ports(_, deviceCode):
            parameters = ["deviceCode": deviceCode]
        case let .cabinetModify(_, cabinet):
            let validateParameters = cabinet.filter{ $0.key != "devices" }
            parameters = validateParameters
        case let .deviceModify(_, device):
            parameters = device
        case let .portLinks(_, code):
            parameters = ["md5str" : code]
        case let .inspectUpload(_, parameters, formData):
            let json = parameters.toJSONString()
            let param = ["json" : json! ]
            return .uploadCompositeMultipart(formData, urlParameters: param)
        }
        
        return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
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
