//
//  RMLoginViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 22/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import RealmSwift
import Moya_ObjectMapper
import RxSwift
import RxCocoa



class RMLoginViewController: RMViewController, RMLoginViewModelAction {
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let input = (usernameTextField.rx.text.orEmpty.asDriver(),
                     passwordTextField.rx.text.orEmpty.asDriver(),
                     loginButton.rx.tap.asDriver())
        
        let dependency = (RMLoginDomain.shared, RMLoginValidate.shared)
        
        let viewModel = RMLoginViewModel(input: input,dependency: dependency , loginAction: self)
        
        viewModel.signedIn.drive(onNext: { [weak self] success in
            if success { self?.perform(segue: StoryboardSegue.Main.toMain, sender: self) }
        }).disposed(by: disposeBag)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        switch StoryboardSegue.Main(rawValue: segue.identifier!)! {
        case .toMain: break
        default: break
        }
     }
    
}
