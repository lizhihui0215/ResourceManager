//
//  RMLinkDetailViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 06/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift
import PCCWFoundationSwift

protocol RMLinkDetailAction: PFSViewAction {
    
}

class RMLevel: RMPickerViewItem {
    var title: String = ""
    
    init(title: String){
        self.title = title
    }
}

class RMPortItem: RMPickerViewItem {
    var title: String = ""
    
    
    init(port: String) {
        self.title = port
    }
    
    func port() -> String {
        return self.title
    }
    
}

class RMLinkDetailViewModel: PFSViewModel<RMLinkDetailViewController, RMLinkDetailDomain> {
    
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
    var serviceLevel: Variable<String>
    var orderNo: Variable<String>
    var accessDevicePortType: Variable<String>
    var farendDevicePortType: Variable<String>
    var businessType: Variable<String>
    
    
    
    var billingNo: Variable<String>
    
    
    var accessDevice: RMDevice?
    
    var farendDevice: RMDevice?
    
    var accessPort: Int = 0
    
    var farendPort: Int = 0
    
    var isModify: Bool
    
    init(link: RMLink, action: RMLinkDetailViewController, isModify: Bool = false) {
        self.link = link
        self.isModify = isModify
        account = Variable(link.linkName ?? "")
        linkRate = Variable(link.linkRate ?? "")
        linkCode = Variable(link.linkCode ?? "")
        customerName = Variable(link.customerName ?? "")
        customerLevel = Variable(link.customerLevel ?? "")
        farendDeviceName = Variable(link.farendDeviceName ?? "")
        farendDevicePort = Variable(link.farendDevicePort ?? "")
        accessDevicePort = Variable(link.accessDevicePort ?? "")
        accessDeviceName = Variable(link.accessDeviceName ?? "")
        farendDeviceId = Variable( link.farendDeviceId ?? "")
        accessDeviceId = Variable(link.accessDeviceId ?? "")
        serviceLevel = Variable(link.serviceLevel ?? "")
        accessDevicePortType = Variable(link.accessDevicePortType ?? "")
        farendDevicePortType = Variable(link.farendDevicePortType   ?? "")
        
        
        orderNo = Variable(link.orderNo ?? "")
        billingNo = Variable(link.billingNo ?? "")
        businessType = Variable(link.businessType ?? "")
        super.init(action: action, domain: RMLinkDetailDomain())
        
        accessDevicePortType.asObservable().bind {
            link.accessDevicePortType = $0
            }.addDisposableTo(disposeBag)
        
        farendDevicePortType.asObservable().bind {
            link.farendDevicePortType = $0
            }.addDisposableTo(disposeBag)
        
        businessType.asObservable().bind {
            link.businessType = $0
            }.addDisposableTo(disposeBag)
        
        
        serviceLevel.asObservable().bind {
            link.serviceLevel = $0
            }.addDisposableTo(disposeBag)
        
        farendDeviceId.asObservable().bind {
            link.farendDeviceId = $0
            }.addDisposableTo(disposeBag)
        
        accessDeviceId.asObservable().bind {
            link.accessDeviceId = $0
            }.addDisposableTo(disposeBag)
        
        account.asObservable().bind { account in
            link.linkName = account
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
            link.farendDevicePort = farendDevicePort
            }.addDisposableTo(disposeBag)
        
        accessDevicePort.asObservable().bind { accessDevicePort in
            link.accessDevicePort = accessDevicePort
            }.addDisposableTo(disposeBag)
        
        accessDeviceName.asObservable().bind { accessDeviceName in
            link.accessDeviceName = accessDeviceName
            }.addDisposableTo(disposeBag)
        
        orderNo.asObservable().bind { orderNo in
            link.orderNo = orderNo
            }.addDisposableTo(disposeBag)
        
        billingNo.asObservable().bind { billingNo in
            link.billingNo = billingNo
            }.addDisposableTo(disposeBag)
        
    }
    
    func freePort(isAccess: Bool) -> Driver<[String]> {
        let deviceCode = isAccess ? accessDeviceId.value : farendDeviceId.value
        
        let message = isAccess ? "请选择本端设备" : "请选择对端设备"
        
        let validateDeviceCode = deviceCode.notNull(message: message)
        
        
        let validateResult = PFSValidate.of(validateDeviceCode)

        return validateResult.flatMapLatest{ _ in
            return self.domain.ports(deviceCode: deviceCode)
            }.flatMapLatest { result  in
                return  self.action!.alert(result: result).flatMapLatest{ _ in
                    switch result {
                    case .success(let ports):
                        return Driver.just(ports)
                    default:
                        return Driver.just([String]())
                    }
                }
        }
    }
    
    func linkModify() -> Driver<Bool> {
        if link.farendDevicePort == "" {
            return self.action!.alert(message: "请选择对端端口", success: false)
        }
        
        if link.accessDevicePort == "" {
            return self.action!.alert(message: "请选择本端端口", success: false)
        }
        
        return self.domain.linkModify(link: self.link)
            .flatMapLatest({ result  in
                return self.action!.alert(result: result)
            }).flatMapLatest({ _  in
                return self.action!.alert(message: "修改成功！", success: true)
            })
    }
}
