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

class RMLoginViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        
        RMNetworkServicesProvider.request(.login(usernameTextField.text!,
                                                 passwordTextField.text!)).mapObject(RMResponseObject<RMUser>.self).subscribe
            { event in
                switch event {
                case .next(let responseObject):
                    print(responseObject)
                      let a = try? responseObject.results?.first!
                    
                    break
                    
                    
                default: break
                }
                                                    
            }.dispose()
        
       let a = RMNetworkServices.shared.request(.login(usernameTextField.text!,
                                                       passwordTextField.text!)).subscribe
                                                        { event in
                                                            switch event {
                                                            case .next(let responseObject):
                                                                print(responseObject)
                                                                try? responseObject.results?.first!
                                                                
                                                                break
                                                                 
                                                                
                                                            default: break
                                                            }
                                                            
                                                        }.dispose()

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
