//
//  RMDevice.swift
//  ResourceManager
//
//  Created by 李智慧 on 30/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import Foundation
import DeviceKit
import KeychainAccess

let keychain = Keychain()

let device = Device()

extension Device{
    public var appVersion: String {
        return NSBundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    public var appName: String{
        return NSBundle.main.infoDictionary!["CFBundleExecutable"] as! String
    }
    
    public var uuid: String {

        if let uuid = keychain["uuid"] {
            return uuid
        }
        
        let uuid = UUID().uuidString
        
        keychain["uuid"] = uuid
        
        return uuid
    }
}
