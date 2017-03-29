//
//  RMLinkNodeView.swift
//  ResourceManager
//
//  Created by 李智慧 on 29/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import SnapKit

class RMLinkNodeView: UIView {
    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var textField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let label = UILabel()
        let textField = UITextField()
        
        self.addSubview(label)
        self.addSubview(textField)
        
        self.label = label
        self.textField = textField
        
        self.label.text = "qqqqq"
        
        self.textField.borderStyle = .roundedRect
        
        self.snp.makeConstraints { (maker) in
            maker.height.equalTo(40)
        }
        
        label.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self).offset(10)
            maker.centerY.equalTo(self.snp.centerY)
        }
        
        label.setContentHuggingPriority(253, for: .horizontal)
        
        textField.snp.makeConstraints { (maker) in
            maker.leading.equalTo(label.snp.trailing).offset(5)
            maker.trailing.equalTo(self).offset(10)
            maker.centerY.equalTo(label.snp.centerY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
   
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
