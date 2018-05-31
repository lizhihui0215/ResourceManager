//
//  RMDataRepositoryswift.swift
//  ResourceManager
//
//  Created by 李智慧 on 28/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxSwift
import RxCocoa
import Result
import Moya
import RealmSwift
import PCCWFoundationSwift
import class Alamofire.NetworkReachabilityManager

class RMDataRepository:  PFSDataRepository{
    let networkReachabilityManager = NetworkReachabilityManager()!

    static let shared = RMDataRepository()

    var user: RMUser? {
        get {
            return PFSDomain.login()
        }
    }


    func sigin(username: String, password: String) -> Driver<Result<RMUser, MoyaError>> {
        if networkReachabilityManager.isReachable {
            let result: Single<PFSResponseMappableObject<RMUser>> = PFSNetworkService<RMAPITarget>.shared.request(.login(username, password))
            
            return self.handlerError(response: result).map { result in
                switch result {
                case .success(let user):
                    return Result(value: user)
                case.failure(let error) :
                    return Result(error: error)
                }
            }
        }
        
        let user: RMUser? = PFSRealm.shared.object("loginName = %@", username)
        
        guard let theUser = user else {
            return Driver.just(Result(error: error(message: "用户不存在！")))
        }
        
        guard theUser.password == password else {
            return Driver.just(Result(error: error(message: "密码不正确！")))
        }
        
        return Driver.just(Result(value: theUser))
    }

    func offlineData() -> Driver<Result<[RMCabinet], MoyaError>> {
        let result: Single<PFSResponseMappableArray<RMCabinet>> = PFSNetworkService<RMAPITarget>.shared.request(.offlineData((self.user?.accessToken)!, "0"))

        return self.handlerError(response: result).map { result  in
            switch result {
            case .success(let cabinets):
                return Result(value: cabinets)
            case .failure(let error):
                return Result(error: error)
            }
        }
    }

    func link(deviceCode: String) -> Driver<Result<[RMLink], MoyaError>> {
        if networkReachabilityManager.isReachable {
            let resukt: Single<PFSResponseMappableArray<RMLink>> = PFSNetworkService<RMAPITarget>.shared.request(.link((self.user?.accessToken)!, deviceCode))
            return self.handlerError(response: resukt).map({ result in
                switch result {
                case .success(let links):
                    return Result(value: links)
                case .failure(let error):
                    return Result(error: error)
                }
            })
        }
        
        let ports: [RMPort] = PFSRealm.shared.objects(offset: nil, limit: nil, predicateFormat: "deviceCode = %@", deviceCode)
        
        var links = [RMLink]()
        
        for port in ports {
            let linksOfPort = port.links.toArray()
            
            links.append(contentsOf: linksOfPort)
            
        }
        
        return Driver.just(Result(value: links))
    }
    
    func linkList(account: String, customerName: String, linkCode: String, page: Int, size: Int) -> Driver<Result<[RMLink], MoyaError>> {
        
        if networkReachabilityManager.isReachable {
            let resukt: Single<PFSResponseMappableArray<RMLink>> = PFSNetworkService<RMAPITarget>.shared.request(.linkList((self.user?.accessToken)!, account, customerName, linkCode, page, size))
            
            return self.handlerError(response: resukt).map({ result in
                switch result {
                case .success(let links):
                    return Result(value: links)
                case .failure(let error):
                    return Result(error: error)
                }
            })
        }
        
        let links: [RMLink] = PFSRealm.shared.objects(offset: page, limit: size, predicateFormat: "linkCode CONTAINS %@ OR linkName CONTAINS %@ OR customerName CONTAINS %@", linkCode, account, customerName)

        return Driver.just(Result(value: links))
    }
    
    func inspectList(page: Int, size: Int) -> Driver<Result<[RMInspect], MoyaError>> {
        let resukt: Single<PFSResponseMappableArray<RMInspect>> = PFSNetworkService<RMAPITarget>.shared.request(.inspectList((self.user?.accessToken)!, page, size))
        
        return self.handlerError(response: resukt).map({ result in
            switch result {
            case .success(let links):
                return Result(value: links)
            case .failure(let error):
                return Result(error: error)
            }
        })
    }
    
    func deviceList(deviceCode: String, deviceName: String, page: Int, size: Int) -> Driver<Result<[RMDevice], MoyaError>> {
        if networkReachabilityManager.isReachable {
            let resukt: Single<PFSResponseMappableArray<RMDevice>> = PFSNetworkService<RMAPITarget>.shared.request(.deviceList((self.user?.accessToken)!, deviceCode, deviceName, page, size))
            
            return self.handlerError(response: resukt).map({ result in
                switch result {
                case .success(let links):
                    return Result(value: links)
                case .failure(let error):
                    return Result(error: error)
                }
            })
        }
        
        let devices: [RMDevice] = PFSRealm.shared.objects(offset: page, limit: size, predicateFormat: "deviceCode CONTAINS %@", deviceCode)
        
        return Driver.just(Result(value: devices))
        
        
    }

    
    func cabinetList(account: String, customerName: String, linkCode: String, page: Int, size: Int) -> Driver<Result<[RMCabinet], MoyaError>> {

        if networkReachabilityManager.isReachable {
            let resukt: Single<PFSResponseMappableArray<RMCabinet>> = PFSNetworkService<RMAPITarget>.shared.request(.cabinetList((self.user?.accessToken)!, account, customerName, linkCode, page, size))

            return self.handlerError(response: resukt).map({ result in
                switch result {
                case .success(let links):
                    return Result(value: links)
                case .failure(let error):
                    return Result(error: error)
                }
            })
        }

        let cabinets: [RMCabinet] = PFSRealm.shared.objects(offset: page, limit: size, predicateFormat: "cabinetCode CONTAINS %@", account)

        return Driver.just(Result(value: cabinets))
    }

    func ports(deviceCode: String) -> Driver<Result<[String], MoyaError>> {
        let result: Single<PFSResponseArray<String>> = PFSNetworkService<RMAPITarget>.shared.request(.ports((self.user?.accessToken)!, deviceCode))
        return self.handlerError(response: result).map{ result in
            switch result {
            case.success(let device):
                return Result(value: device)
            case.failure(let error):
                return Result(error: error)
            }
        }
    }
    
    func link(linkCode: String) -> Driver<Result<RMLink, MoyaError>> {
        if networkReachabilityManager.isReachable {
            let result: Single<PFSResponseMappableObject<RMLink>> = PFSNetworkService<RMAPITarget>.shared.request(.linkDetail((self.user?.accessToken)!, linkCode))
            
            return self.handlerError(response: result).map{ result in
                switch result {
                case.success(let link):
                    return Result(value: link)
                case.failure(let error):
                    return Result(error: error)
                }
            }
        }
        
        let link: RMLink? = PFSRealm.shared.object("linkId = %@", linkCode)
        
        guard let theLink = link else {
            return Driver.just(Result(error: error(message: "查询无结果")))
        }
        
        return Driver.just(Result(value: theLink))
    }
    
    func portLinks(code: String) -> Driver<Result<[RMLink], MoyaError>> {
        let result: Single<PFSResponseMappableArray<RMLink>> = PFSNetworkService<RMAPITarget>.shared.request(.portLinks((self.user?.accessToken)!, code))
        
        return self.handlerError(response: result).map{ result in
            switch result {
            case.success(let link):
                return Result(value: link)
            case.failure(let error):
                return Result(error: error)
            }
        }
    }
    
    func exchangePassword(password: String, newPassword: String) -> Driver<Result<String, MoyaError>> {
        let result: Single<PFSResponseNil> = PFSNetworkService<RMAPITarget>.shared.request(.exchangePassword((self.user?.accessToken)!, password,newPassword))
        
        return self.handlerError(response: result).map{ result in
            switch result {
            case.success(let link):
                return Result(value: link)
            case.failure(let error):
                return Result(error: error)
            }
        }
    }
    
    func suggest(name: String, phone: String, detail: String) -> Driver<Result<String, MoyaError>> {
        let result: Single<PFSResponseNil> = PFSNetworkService<RMAPITarget>.shared.request(.suggest((self.user?.accessToken)!, name,phone,detail))
        
        return self.handlerError(response: result).map{ result in
            switch result {
            case.success(let link):
                return Result(value: link)
            case.failure(let error):
                return Result(error: error)
            }
        }
    }
    
    func linkModify(link: RMLink) -> Driver<Result<String, MoyaError>> {
        var json: [String : Any]!
        try? PFSRealm.realm.write {
            json = link.toJSON()
        }

        let result: Single<PFSResponseNil> = PFSNetworkService<RMAPITarget>.shared.request(.linkModify((self.user?.accessToken)!, json))
        
        return self.handlerError(response: result).map{ result in
            switch result {
            case.success(let link):
                return Result(value: link)
            case.failure(let error):
                return Result(error: error)
            }
        }
    }

    func modifyCabinet(cabinet: RMCabinet) -> Driver<Result<String, MoyaError>> {
        var json: [String : Any]!
        try? PFSRealm.realm.write {
            json = cabinet.toJSON()
        }
        
        let result: Single<PFSResponseNil> = PFSNetworkService<RMAPITarget>.shared.request(.cabinetModify((self.user?.accessToken)!, json))

        return self.handlerError(response: result).map{ result in
            switch result {
            case.success(let link):
                return Result(value: link)
            case.failure(let error):
                return Result(error: error)
            }
        }
    }
    
    func modifyDevice(device: RMDevice) -> Driver<Result<String, MoyaError>> {
        var json: [String : Any]!
        try? PFSRealm.realm.write {
           json = device.toJSON()
        }
        
        let result: Single<PFSResponseNil> = PFSNetworkService<RMAPITarget>.shared.request(.deviceModify((self.user?.accessToken)!, json))
        
        return self.handlerError(response: result).map{ result in
            switch result {
            case.success(let link):
                return Result(value: link)
            case.failure(let error):
                return Result(error: error)
            }
        }
    }
    
    func inspectUpload(parameter: [String : Any], images: [MultipartFormData] ) -> Driver<Result<String, MoyaError>> {
        let result: Single<PFSResponseNil> = PFSNetworkService<RMAPITarget>.shared.request(.inspectUpload((self.user?.accessToken)!, parameter, images))
        
        return self.handlerError(response: result).map{ result in
            switch result {
            case.success(let link):
                return Result(value: link)
            case.failure(let error):
                return Result(error: error)
            }
        }
    }
    
    func device(deviceCode: String) -> Driver<Result<RMDevice, MoyaError>> {
        
        
        if networkReachabilityManager.isReachable {
            let result: Single<PFSResponseMappableObject<RMDevice>> = PFSNetworkService<RMAPITarget>.shared.request(.deviceDetail((self.user?.accessToken)!, deviceCode))
            
            return self.handlerError(response: result).map{ result in
                switch result {
                case.success(let device):
                    return Result(value: device)
                case.failure(let error):
                    return Result(error: error)
                }
            }
        }
        
        let device: RMDevice? = PFSRealm.shared.object("deviceCode = %@", deviceCode)
        
        guard let theDevice = device else {
            return Driver.just(Result(error: error(message: "查询无结果")))
        }
        
        return Driver.just(Result(value: theDevice))
    }
    
    func cabinet(cabinetId: String) -> Driver<Result<RMCabinet, MoyaError>> {
        if networkReachabilityManager.isReachable {
            let result: Single<PFSResponseMappableObject<RMCabinet>> = PFSNetworkService<RMAPITarget>.shared.request(.cabinetDetail((self.user?.accessToken)!, cabinetId))
            
            return self.handlerError(response: result).map{ result in
                switch result {
                case.success(let link):
                    return Result(value: link)
                case.failure(let error):
                    return Result(error: error)
                }
            }
        }
        
        let cabinet: RMCabinet? = PFSRealm.shared.object("cabinetId = %@", cabinetId)
        
        guard let theCabinet = cabinet else {
            return Driver.just(Result(error: error(message: "查询无结果")))
        }
        
        return Driver.just(Result(value: theCabinet))
    }
   
}

