//
//  PrintServices.swift
//  ResourceManager
//
//  Created by 李智慧 on 24/05/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import Foundation

class PrintServices {
    var print: Print
    static let shared = PrintServices()
    
    init() {
        print = Print()
    }
    
    func printInView(view: UIView, template: String)  {
        print.view = view
        print.printContent(template, printName: "", lableW: 320, lableH: 480)
    }
    
    deinit {
       _ = print.closePrint()
    }
    
}


