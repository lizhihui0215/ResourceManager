//
//  RMLinkSearchViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 29/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit



class RMLinkSearchViewController: RMViewController, RMSearchListAction {
    
    var viewModel: RMLinkSearchViewModel?
    
    @IBOutlet weak var linkCodeTextField: UITextField!
    @IBOutlet weak var customerTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.viewModel = RMLinkSearchViewModel(actions: self)
        
        let _ = self.accountTextField.rx.textInput <-> (self.viewModel?.account)!
        
        let _ = self.customerTextField.rx.textInput <-> (self.viewModel?.customerName)!
        
        let _ = self.linkCodeTextField.rx.textInput <-> (self.viewModel?.linkCode)!
        
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        self.viewModel?.linkList(refresh: true).drive(onNext: { success in
            if success {
                self.performSegue(withIdentifier: "toLinkList", sender: nil)
            }
        }).disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toLinkList" {
            let linkListViewController = segue.destination as! RMLinkListViewController
            
            linkListViewController.viewModel = RMLinkListViewModel(action: linkListViewController)
            
            let _ = linkListViewController.viewModel?.section(at: 0).append(contentsOf: (self.viewModel?.links)!)
            
            linkListViewController.viewModel?.account.value = (self.viewModel?.account.value)!
            
            linkListViewController.viewModel?.customerName.value = (self.viewModel?.customerName.value)!
            linkListViewController.viewModel?.linkCode.value = (self.viewModel?.linkCode.value)!
        }
    }
}
