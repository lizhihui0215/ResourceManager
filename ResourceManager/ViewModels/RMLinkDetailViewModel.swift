//
//  RMLinkDetailViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 06/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift

protocol RMLinkDetailAction: RMViewModelAction {
    
}

class RMPortItem: RMPickerViewItem {
    var title: String = ""
    
    
    init(port: Int) {
        self.title = String(port)
    }
    
    func port() -> Int {
        return Int(self.title)!
    }

}

class RMLinkDetailViewModel: RMViewModel {
    
    var link: RMLink
    
    var account: Variable<String>
    var linkRate: Variable<String>
    var linkCode: Variable<String>
    var customerName: Variable<String>
    var customerLevel: Variable<String>
    var farendDevicePort: Variable<String>
    var farendDeviceName: Variable<String>
    var accessDevicePort: Variable<String>
    var accessDeviceName: Variable<String>
    var farendDeviceId: Variable<String>
    var accessDeviceId: Variable<String>
    
    
    var accessDevice: RMDevice?
    
    var farendDevice: RMDevice?
    
    var accessPort: Int = 0
    
    var farendPort: Int = 0
    
    var isModify: Bool
    
    var action: RMLinkDetailAction
    
    
    init(link: RMLink, action: RMLinkDetailAction, isModify: Bool = false) {
        self.link = link
        self.isModify = isModify
        self.action = action
        account = Variable(link.account ?? "")
        linkRate = Variable(link.linkRate ?? "")
        linkCode = Variable(link.linkCode ?? "")
        customerName = Variable(link.customerName ?? "")
        customerLevel = Variable(link.customerLevel ?? "")
        farendDeviceName = Variable(link.farendDeviceName ?? "")
        farendDevicePort = Variable(String(link.farendDevicePort) )
        accessDevicePort = Variable(String(link.accessDevicePort) )
        accessDeviceName = Variable(link.accessDeviceName ?? "")
        farendDeviceId = Variable( link.farendDeviceId ?? "")
        accessDeviceId = Variable(link.accessDeviceId ?? "")
        
        super.init()
        
        farendDeviceId.asObservable().bind {
            link.farendDeviceId = $0
        }.addDisposableTo(disposeBag)
        
        accessDeviceId.asObservable().bind {
            link.accessDeviceId = $0
            }.addDisposableTo(disposeBag)
        
        account.asObservable().bind { account in
            link.account = account
            }.addDisposableTo(disposeBag)
        
        linkRate.asObservable().bind { linkRate in
            link.linkRate = linkRate
            }.addDisposableTo(disposeBag)
        
        linkCode.asObservable().bind { linkCode in
            link.linkCode = linkCode
            }.addDisposableTo(disposeBag)
        
        customerName.asObservable().bind { customerName in
            link.customerName = customerName
            }.addDisposableTo(disposeBag)
        
        customerLevel.asObservable().bind { customerLevel in
            link.customerLevel = customerLevel
            }.addDisposableTo(disposeBag)
        
        farendDeviceName.asObservable().bind { farendDeviceName in
            link.farendDeviceName = farendDeviceName
            }.addDisposableTo(disposeBag)
        
        farendDevicePort.asObservable().bind { farendDevicePort in
            link.farendDevicePort = Int(farendDevicePort) ?? 0
            }.addDisposableTo(disposeBag)
        
        accessDevicePort.asObservable().bind { accessDevicePort in
            link.accessDevicePort = Int(accessDevicePort) ?? 0
            }.addDisposableTo(disposeBag)
        
        accessDeviceName.asObservable().bind { accessDeviceName in
            link.accessDeviceName = accessDeviceName
            }.addDisposableTo(disposeBag)
    }
    
    func freePort(isAccess: Bool) -> Driver<[Int]> {
        self.action.animation.value = true
        
        let deviceCode = isAccess ? accessDeviceId.value : farendDeviceId.value
        
        
        let message = isAccess ? "请选择本端设备" : "请选择对端设备"
       return RMLinkDetailValidate.shared.validateNil(deviceCode, message: message).flatMapLatest{
            return RMLinkDetailDomain.shared.ports(deviceCode: $0.value!)
            }.do(onNext: { result in
                self.action.animation.value = false
            }).flatMapLatest { result  in
                return  self.action.alert(result: result).flatMapLatest{ _ in
                    
                    switch result {
                    case .success(let ports):
                        return Driver.just(ports)
                    default:
                        return Driver.just([Int]())
                    }
                }
        }
        
        
    }
    
    func linkModify() -> Driver<Bool> {
        self.action.animation.value = true
        return RMLinkDetailDomain.shared.linkModify(link: self.link)
            .do(onNext: { [weak self] result in
                
                if let strongSelf = self {
                    strongSelf.action.animation.value = false
                }
            })            .flatMapLatest({ result  in
                return self.action.alert(result: result)
            }).flatMapLatest({ _  in
                return self.action.alert(message: "修改成功！")
            })
    }
    
    
}
