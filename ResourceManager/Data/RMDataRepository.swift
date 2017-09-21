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

class RMDataRepository:  PFSDataRepository{
    static let shared = RMDataRepository()

    func sigin(username: String, password: String) -> Driver<Result<RMUser, MoyaError>> {
//        let result: Single<PFSResponseMappableObject<IBLUser>> = PFSNetworkService<IBLAPITarget>.shared.request(.portalAuth(account, password, auth))

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
    
    func link(deviceCode: String) -> Driver<Result<[RMLink], MoyaError>> {
        let resukt: Single<PFSResponseMappableArray<RMLink>> = PFSNetworkService<RMAPITarget>.shared.request(.link((RMDomain.user?.accessToken)!, deviceCode))
        
        return self.handlerError(response: resukt).map({ result in
            switch result {
            case .success(let links):
                return Result(value: links)
            case .failure(let error):
                return Result(error: error)
            }
        })
    }
    
    func linkList(account: String, customerName: String, linkCode: String, page: Int, size: Int) -> Driver<Result<[RMLink], MoyaError>> {
        let resukt: Single<PFSResponseMappableArray<RMLink>> = PFSNetworkService<RMAPITarget>.shared.request(.linkList((RMDomain.user?.accessToken)!, account, customerName, linkCode, page, size))
        
        return self.handlerError(response: resukt).map({ result in
            switch result {
            case .success(let links):
                return Result(value: links)
            case .failure(let error):
                return Result(error: error)
            }
        })
    }
    
    func inspectList(page: Int, size: Int) -> Driver<Result<[RMInspect], MoyaError>> {
        let resukt: Single<PFSResponseMappableArray<RMInspect>> = PFSNetworkService<RMAPITarget>.shared.request(.inspectList((RMDomain.user?.accessToken)!, page, size))
        
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
        let resukt: Single<PFSResponseMappableArray<RMDevice>> = PFSNetworkService<RMAPITarget>.shared.request(.deviceList((RMDomain.user?.accessToken)!, deviceCode, deviceName, page, size))
        
        return self.handlerError(response: resukt).map({ result in
            switch result {
            case .success(let links):
                return Result(value: links)
            case .failure(let error):
                return Result(error: error)
            }
        })
    }

    
    func cabinetList(account: String, customerName: String, linkCode: String, page: Int, size: Int) -> Driver<Result<[RMCabinet], MoyaError>> {
        let resukt: Single<PFSResponseMappableArray<RMCabinet>> = PFSNetworkService<RMAPITarget>.shared.request(.cabinetList((RMDomain.user?.accessToken)!, account, customerName, linkCode, page, size))
        
        return self.handlerError(response: resukt).map({ result in
            switch result {
            case .success(let links):
                return Result(value: links)
            case .failure(let error):
                return Result(error: error)
            }
        })
    }

    func ports(deviceCode: String) -> Driver<Result<[String], MoyaError>> {
        let result: Single<PFSResponseArray<String>> = PFSNetworkService<RMAPITarget>.shared.request(.ports((RMDomain.user?.accessToken)!, deviceCode))
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
        let result: Single<PFSResponseMappableObject<RMLink>> = PFSNetworkService<RMAPITarget>.shared.request(.linkDetail((RMDomain.user?.accessToken)!, linkCode))
        
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
        let result: Single<PFSResponseNil> = PFSNetworkService<RMAPITarget>.shared.request(.exchangePassword((RMDomain.user?.accessToken)!, password,newPassword))
        
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
        let result: Single<PFSResponseNil> = PFSNetworkService<RMAPITarget>.shared.request(.suggest((RMDomain.user?.accessToken)!, name,phone,detail))
        
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
        let result: Single<PFSResponseNil> = PFSNetworkService<RMAPITarget>.shared.request(.linkModify((RMDomain.user?.accessToken)!, link.toJSON()))
        
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
        let result: Single<PFSResponseNil> = PFSNetworkService<RMAPITarget>.shared.request(.cabinetModify((RMDomain.user?.accessToken)!, cabinet.toJSON()))

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
        let result: Single<PFSResponseNil> = PFSNetworkService<RMAPITarget>.shared.request(.deviceModify((RMDomain.user?.accessToken)!, device.toJSON()))
        
        return self.handlerError(response: result).map{ result in
            switch result {
            case.success(let link):
                return Result(value: link)
            case.failure(let error):
                return Result(error: error)
            }
        }
    }
    
    
    
    func user() -> Observable<Result<RMUser, MoyaError>> {
        return Observable.just(Result(value: RMDomain.user!))
    }
    
    func inspectUpload(parameter: [String : Any], images: [MultipartFormData] ) -> Driver<Result<String, MoyaError>> {
        let result: Single<PFSResponseNil> = PFSNetworkService<RMAPITarget>.shared.request(.inspectUpload((RMDomain.user?.accessToken)!, parameter, images))
        
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
        let result: Single<PFSResponseMappableObject<RMDevice>> = PFSNetworkService<RMAPITarget>.shared.request(.deviceDetail((RMDomain.user?.accessToken)!, deviceCode))
        
        return self.handlerError(response: result).map{ result in
            switch result {
            case.success(let device):
                return Result(value: device)
            case.failure(let error):
                return Result(error: error)
            }
        }
    }
    
    func cabinet(cabinetId: String) -> Driver<Result<RMCabinet, MoyaError>> {
        let result: Single<PFSResponseMappableObject<RMCabinet>> = PFSNetworkService<RMAPITarget>.shared.request(.cabinetDetail((RMDomain.user?.accessToken)!, cabinetId))
        
        return self.handlerError(response: result).map{ result in
            switch result {
            case.success(let link):
                return Result(value: link)
            case.failure(let error):
                return Result(error: error)
            }
        }
    }
   
}

