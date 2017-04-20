//
//  RMDeviceViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/9.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import UIKit
import RSKGrowingTextView
import RxSwift
import RxCocoa

extension RMDeviceViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 8.0
        return CGSize(width: width, height: width)
    }
}

extension RMDeviceViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.numberOfRowsInSection(section: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RMDevicePortCell", for: indexPath) as! RMDevicePortCell
        
        let devicePort = self.viewModel?.elementAt(indexPath: indexPath)
        
        cell.imageView.image = devicePort?.image()
        
        cell.titleLabel.text = "\(indexPath.row + 1)"
        
        cell.titleLabel.textColor = devicePort?.titleColor()
        
        return cell
    }
    
}

class RMDevicePortCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
}

class RMDeviceViewController: RMViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: RMDeviceDetailViewModel?
    
    @IBOutlet weak var deviceCodeTextField: UITextField!
    @IBOutlet weak var deviceLocationTextField: RSKGrowingTextView!
    @IBOutlet weak var deviceNameTextField: UITextField!
    @IBOutlet weak var totalTerminalsTextField: UITextField!
    @IBOutlet weak var terminalOccupiedTextField: UITextField!
    @IBOutlet weak var terminalFreeTextField: UITextField!
    @IBOutlet weak var deviceDescTextField: RSKGrowingTextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.deviceLocationTextField.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.deviceDescTextField.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        if let viewModel = self.viewModel {
            deviceCodeTextField.rx.textInput <-> viewModel.deviceCode
            deviceLocationTextField.rx.textInput <-> viewModel.deviceLocation
            deviceNameTextField.rx.textInput <-> viewModel.deviceName
            totalTerminalsTextField.rx.textInput <-> viewModel.totalTerminals
            terminalOccupiedTextField.rx.textInput <-> viewModel.terminalOccupied
            terminalFreeTextField.rx.textInput <-> viewModel.terminalFree
            deviceDescTextField.rx.textInput <-> viewModel.deviceDesc
        }
        
        deviceCodeTextField.backgroundColor = UIColor.white
        deviceNameTextField.backgroundColor = UIColor.white
        totalTerminalsTextField.backgroundColor = UIColor.white
        terminalOccupiedTextField.backgroundColor = UIColor.white
        terminalFreeTextField.backgroundColor = UIColor.white
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
