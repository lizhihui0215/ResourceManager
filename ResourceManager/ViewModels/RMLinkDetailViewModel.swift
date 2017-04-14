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
        farendDevicePort = Variable(link.farendDevicePort ?? "")
        accessDevicePort = Variable(link.accessDevicePort ?? "")
        accessDeviceName = Variable(link.accessDeviceName ?? "")
        
        super.init()

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
            link.farendDevicePort = farendDevicePort
            }.addDisposableTo(disposeBag)
        
        accessDevicePort.asObservable().bind { accessDevicePort in
            link.accessDevicePort = accessDevicePort
            }.addDisposableTo(disposeBag)
        
        accessDeviceName.asObservable().bind { accessDeviceName in
            link.accessDeviceName = accessDeviceName
            }.addDisposableTo(disposeBag)
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
            })
    }
}
