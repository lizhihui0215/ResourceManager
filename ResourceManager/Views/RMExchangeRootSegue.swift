//
//  RMExchangeRootSegue.swift
//  ResourceManager
//
//  Created by 李智慧 on 22/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit

class RMExchangeRootSegue: UIStoryboardSegue {

    override init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination);
    }
    
    override func perform() {
        RMAppDelegate.shared.window?.rootViewController = self.destination;
    }
}
