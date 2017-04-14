//
//  RMPickerView.swift
//  RMPickerView
//
//  Created by 李智慧 on 13/04/2017.
//  Copyright © 2017 PCCW. All rights reserved.
//

import UIKit
import SnapKit

extension UIViewController {
    
    func presentPicker<T: RMPickerViewItem>(items: [T],  completeHandler: @escaping ((_ item: T) -> Void))  {
        let picker = RMPickerView<T>(items: items)
        picker.completeHandler = completeHandler
        
        self.view.addSubview(picker)
        picker.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }
}

protocol RMPickerViewItem {
    var title: String {get set}
}


class RMPickerView<T :RMPickerViewItem>: UIView, UIPickerViewDelegate, UIPickerViewDataSource  {

    fileprivate var pickerView = UIPickerView()
    
    fileprivate var toolBar = UIToolbar()
    
    fileprivate var backgroundView = UIView()
    
    var height: Float = 260
    
    var completeHandler: ((_ item: T) -> Void)?
    
    fileprivate var dataSource: [T] = [T]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return self.dataSource[row].title
    }
    
    convenience init(height: Float = 260, items: [T]) {
        self.init(frame: .zero)
        self.height = height
        self.dataSource.append(contentsOf: items)
        self.pickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func showPicker() {
        
        
    }
    
    override func updateConstraints() {
        
        self.addSubview(backgroundView)
        
        backgroundView.alpha = 0.8
        backgroundView.backgroundColor = UIColor.lightGray
        backgroundView.snp.updateConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        self.addSubview(pickerView)
        
        pickerView.snp.updateConstraints { maker in
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        
        pickerView.backgroundColor = UIColor.white
        
        self.addSubview(toolBar)
        
        toolBar.snp.updateConstraints { maker in
            maker.bottom.equalTo(pickerView.snp.top)
            maker.leading.equalTo(pickerView.snp.leading)
            maker.trailing.equalTo(pickerView.snp.trailing)
        }
        
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        toolBar.addSubview(view)
        
        view.snp.updateConstraints { maker in
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(0.5)
        }
        
        toolBar.isTranslucent = false
        
        let done = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(RMPickerView.done))
        
        let cancel = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(RMPickerView.cancel))
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([cancel, fixedSpace ,done], animated: false)
        
        
        super.updateConstraints()
    }
    
    func done()  {
        self.removeFromSuperview()
        let index = self.pickerView.selectedRow(inComponent: 0)
        if let completeHandler = self.completeHandler {
            completeHandler(self.dataSource[index])
        }
    }
    
    func cancel()  {
        self.removeFromSuperview()
    }
    
    

}
