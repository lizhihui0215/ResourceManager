//
//  RMExchangePasswordViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 17/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit

extension RMExchangePasswordViewController: RMExchangePasswordViewAction {
    
}

class RMExchangePasswordViewController: RMViewController {
    @IBOutlet weak var originPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    var viewModel: RMExchangePasswordViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        self.viewModel?.exchangePassword(originPassword: self.originPasswordTextField.text ?? "",
                                         newPassword: self.newPasswordTextField.text ?? "",
                                         confirmPassword: self.confirmPasswordTextField.text ?? "")
            .drive()
            .disposed(by: disposeBag)
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
