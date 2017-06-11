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

class RMDataRepository {
    
    func sigin(username: String, password: String) -> Observable<Result<RMUser, Moya.Error>> {
        let result: Observable<RMResponseObject<RMUser>> = RMNetworkServices.shared.request(.login(username, password))
        
        return self.handlerError(response: result).map { result in
            switch result {
            case .success(let user):
                return Result(value: user)
            case.failure(let error) :
                return Result(error: error)
            }
        }
    }
    
    func link(deviceCode: String) -> Observable<Result<[RMLink], Moya.Error>> {
        let resukt: Observable<RMResponseArray<RMLink>> = RMNetworkServices.shared.request(.link((RMDomain.user?.accessToken)!, deviceCode))
        
        return self.handlerError(response: resukt).map({ result in
            switch result {
            case .success(let links):
                return Result(value: links)
            case .failure(let error):
                return Result(error: error)
            }
        })
    }
    
    func linkList(account: String, customerName: String, linkCode: String, page: Int, size: Int) -> Observable<Result<[RMLink], Moya.Error>> {
        let resukt: Observable<RMResponseArray<RMLink>> = RMNetworkServices.shared.request(.linkList((RMDomain.user?.accessToken)!, account, customerName, linkCode, page, size))
        
        return self.handlerError(response: resukt).map({ result in
            switch result {
            case .success(let links):
                return Result(value: links)
            case .failure(let error):
                return Result(error: error)
            }
        })
    }
    
    func inspectList(page: Int, size: Int) -> Observable<Result<[RMInspect], Moya.Error>> {
        let resukt: Observable<RMResponseArray<RMInspect>> = RMNetworkServices.shared.request(.inspectList((RMDomain.user?.accessToken)!, page, size))
        
        return self.handlerError(response: resukt).map({ result in
            switch result {
            case .success(let links):
                return Result(value: links)
            case .failure(let error):
                return Result(error: error)
            }
        })
    }
    
    func deviceList(deviceCode: String, deviceName: String, page: Int, size: Int) -> Observable<Result<[RMDevice], Moya.Error>> {
        let resukt: Observable<RMResponseArray<RMDevice>> = RMNetworkServices.shared.request(.deviceList((RMDomain.user?.accessToken)!, deviceCode, deviceName, page, size))
        
        return self.handlerError(response: resukt).map({ result in
            switch result {
            case .success(let links):
                return Result(value: links)
            case .failure(let error):
                return Result(error: error)
            }
        })
    }

    
    func cabinetList(account: String, customerName: String, linkCode: String, page: Int, size: Int) -> Observable<Result<[RMCabinet], Moya.Error>> {
        let resukt: Observable<RMResponseArray<RMCabinet>> = RMNetworkServices.shared.request(.cabinetList((RMDomain.user?.accessToken)!, account, customerName, linkCode, page, size))
        
        return self.handlerError(response: resukt).map({ result in
            switch result {
            case .success(let links):
                return Result(value: links)
            case .failure(let error):
                return Result(error: error)
            }
        })
    }

    func ports(deviceCode: String) -> Observable<Result<[String], Moya.Error>> {
        let result: Observable<RMResponseBaseArray<String>> = RMNetworkServices.shared.request(.ports((RMDomain.user?.accessToken)!, deviceCode))
        return self.handlerError(response: result).map{ result in
            switch result {
            case.success(let device):
                return Result(value: device)
            case.failure(let error):
                return Result(error: error)
            }
        }
    }
    
    func link(linkCode: String) -> Observable<Result<RMLink, Moya.Error>> {
        let result: Observable<RMResponseObject<RMLink>> = RMNetworkServices.shared.request(.linkDetail((RMDomain.user?.accessToken)!, linkCode))
        
        return self.handlerError(response: result).map{ result in
            switch result {
            case.success(let link):
                return Result(value: link)
            case.failure(let error):
                return Result(error: error)
            }
        }
    }
    
    func exchangePassword(password: String, newPassword: String) -> Observable<Result<String, Moya.Error>> {
        let result: Observable<RMResponseNil> = RMNetworkServices.shared.request(.exchangePassword((RMDomain.user?.accessToken)!, password,newPassword))
        
        return self.handlerError(response: result).map{ result in
            switch result {
            case.success(let link):
                return Result(value: link)
            case.failure(let error):
                return Result(error: error)
            }
        }
    }
    
    func suggest(name: String, phone: String, detail: String) -> Observable<Result<String, Moya.Error>> {
        let result: Observable<RMResponseNil> = RMNetworkServices.shared.request(.suggest((RMDomain.user?.accessToken)!, name,phone,detail))
        
        return self.handlerError(response: result).map{ result in
            switch result {
            case.success(let link):
                return Result(value: link)
            case.failure(let error):
                return Result(error: error)
            }
        }
    }
    
    func linkModify(link: RMLink) -> Observable<Result<String, Moya.Error>> {
        let result: Observable<RMResponseNil> = RMNetworkServices.shared.request(.linkModify((RMDomain.user?.accessToken)!, link.toJSON()))
        
        return self.handlerError(response: result).map{ result in
            switch result {
            case.success(let link):
                return Result(value: link)
            case.failure(let error):
                return Result(error: error)
            }
        }
    }

    func modifyCabinet(cabinet: RMCabinet) -> Observable<Result<String, Moya.Error>> {
        let result: Observable<RMResponseNil> = RMNetworkServices.shared.request(.cabinetModify((RMDomain.user?.accessToken)!, cabinet.toJSON()))

        return self.handlerError(response: result).map{ result in
            switch result {
            case.success(let link):
                return Result(value: link)
            case.failure(let error):
                return Result(error: error)
            }
        }
    }
    
    func modifyDevice(device: RMDevice) -> Observable<Result<String, Moya.Error>> {
        let result: Observable<RMResponseNil> = RMNetworkServices.shared.request(.deviceModify((RMDomain.user?.accessToken)!, device.toJSON()))
        
        return self.handlerError(response: result).map{ result in
            switch result {
            case.success(let link):
                return Result(value: link)
            case.failure(let error):
                return Result(error: error)
            }
        }
    }
    
    
    
    func user() -> Observable<Result<RMUser, Moya.Error>> {
        return Observable.just(Result(value: RMDomain.user!))
    }
    
    func inspectUpload(parameter: [String : Any], images: [MultipartFormData] ) -> Observable<Result<String, Moya.Error>> {
        let result: Observable<RMResponseNil> = RMNetworkServices.shared.request(.inspectUpload((RMDomain.user?.accessToken)!, parameter, images))
        
        return self.handlerError(response: result).map{ result in
            switch result {
            case.success(let link):
                return Result(value: link)
            case.failure(let error):
                return Result(error: error)
            }
        }
    }
    
    func device(deviceCode: String) -> Observable<Result<RMDevice, Moya.Error>> {
        let result: Observable<RMResponseObject<RMDevice>> = RMNetworkServices.shared.request(.deviceDetail((RMDomain.user?.accessToken)!, deviceCode))
        
        return self.handlerError(response: result).map{ result in
            switch result {
            case.success(let device):
                return Result(value: device)
            case.failure(let error):
                return Result(error: error)
            }
        }
    }
    
    func cabinet(cabinetId: String) -> Observable<Result<RMCabinet, Moya.Error>> {
        let result: Observable<RMResponseObject<RMCabinet>> = RMNetworkServices.shared.request(.cabinetDetail((RMDomain.user?.accessToken)!, cabinetId))
        
        return self.handlerError(response: result).map{ result in
            switch result {
            case.success(let link):
                return Result(value: link)
            case.failure(let error):
                return Result(error: error)
            }
        }
    }
    
    func handlerError<T>(response: Observable<RMResponseObject<T>>) -> Observable<Result<T, Moya.Error>> {
        return response.map { response  in
            if response.code == 0 {
                return Result(value: response.result!)
            }else {
                return Result(error: error(code: response.code, message: response.message) )
            }
        }
    }
    
    func handlerError(response: Observable<RMResponseNil>, message: String = "") -> Observable<Result<String, Moya.Error>> {
        return response.map { response  in
            if response.code == 0 {
                return Result(value: response.message ?? message)
            }else {
                return Result(error: error(code: response.code, message: response.message) )
            }
        }
    }
    
    func handlerError<T>(response: Observable<RMResponseBaseArray<T>>, message: String = "") -> Observable<Result<[T], Moya.Error>> {
        return response.map { response  in
            if response.code == 0 {
                return Result(value: response.results ?? [T]())
            }else {
                return Result(error: error(code: response.code, message: response.message) )
            }
        }
    }

    
    func handlerError<T>(response: Observable<RMResponseArray<T>>) -> Observable<Result<[T], Moya.Error>> {
        return response.map { response  in
            if response.code == 0 {
                return Result(value: response.results ?? [])
            }else {
                return Result(error: error(code: response.code, message: response.message) )
            }
        }
    }



}

