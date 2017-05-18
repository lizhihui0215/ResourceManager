//
//  RMSuggestViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 17/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit

extension RMSuggestViewController: RMSuggestViewAction {
    
}

class RMSuggestViewController: RMViewController {
    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var detailTextView: RSKGrowingTextView!
    @IBOutlet weak var phoneTextField: UITextField!
    
    var viewModel: RMSuggestViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        let name = nameTextField.text ?? ""
        let detail = detailTextView.text ?? ""
        let phone = phoneTextField.text ?? ""
        
        self.viewModel?.suggest(name: name, phone: phone, detail: detail).drive(onNext: { [weak self] _ in
            
            if let strongSelf = self {
                strongSelf.nameTextField.text = ""
                strongSelf.detailTextView.text = ""
                strongSelf.phoneTextField.text = ""
            }
            
        }).disposed(by: disposeBag)
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
