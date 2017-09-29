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
import PCCWFoundationSwift


class RMLoginViewController: PFSViewController, RMLoginViewModelAction {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var serverURLTextFieldHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var serverURLTextField: UITextField!
    var viewModel: RMLoginViewModel?
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    @IBAction func logoTapped(_ sender: UITapGestureRecognizer) {
        serverURLTextFieldHightConstraint.constant = 40
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        passwordTextField.attributedPlaceholder = NSAttributedString(string: "密码", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "用户名", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        serverURLTextField.attributedPlaceholder = NSAttributedString(string: "服务器地址", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        let usernameImage = UIImage(named: "login.username.icon")
        
        let passwordImage = UIImage(named: "login.password.icon")
        
        serverURLTextField.rx.textInput.text.subscribe(onNext: {[weak self] n in
            if let strongSelf = self {
                let nonMarkedTextValue = strongSelf.serverURLTextField.text
                if let nonMarkedTextValue = nonMarkedTextValue, nonMarkedTextValue != RMAPITarget.kBaseURL {
                    if nonMarkedTextValue.isEmpty {
                        RMAPITarget.kBaseURL = "http://115.28.157.117:9080"
                    }else {
                        RMAPITarget.kBaseURL = nonMarkedTextValue
                    }
                }
            }
        }).disposed(by: disposeBag)
        
        let usernameImageView = UIImageView(image: usernameImage)
        let passwordImageView = UIImageView(image: passwordImage)
        usernameImageView.frame = CGRect(x: 0,
                                         y: 0,
                                         width: (usernameImage?.size.width)!,
                                         height: (usernameImage?.size.height)!)
        passwordImageView.frame = CGRect(x: 0,
                                         y: 0,
                                         width: (passwordImage?.size.width)!,
                                         height: (passwordImage?.size.height)!)
        
        usernameTextField.leftView = usernameImageView
        passwordTextField.leftView = passwordImageView
        usernameTextField.leftViewMode = .always
        passwordTextField.leftViewMode = .always
        
        self.viewModel = RMLoginViewModel(action: self, domain: RMLoginDomain())
        self.usernameTextField.rx.textInput <-> (self.viewModel?.username)!
        self.passwordTextField.rx.textInput <-> (self.viewModel?.password)!
        self.viewModel?.user().drive().disposed(by: disposeBag)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        self.viewModel?.sigin().drive(onNext: { success in
            if success { self.perform(segue: StoryboardSegue.Main.toMain, sender: self) }
        }).disposed(by: disposeBag)
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
