//
//  RMLinkSearchViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 29/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import swiftScan

class RMLinkTableViewCell: RMTableViewCell {
    
}

class RMLinkSearchViewController: RMTableViewController, UITableViewDataSource, RMSearchListAction {
    
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
        
        self.tableView.headerRefresh(enable: true, target: self)
        
        self.tableView.footerRefresh(enable: true, target: self)
    }
    
    @IBAction func scanButtonPressed(_ sender: UIButton) {
        //设置扫码区域参数
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        self.viewModel?.linkList(refresh: true).drive(onNext: { (result) in
            print("next")
        }, onCompleted: {
            self.tableView.reloadData()
        }, onDisposed: {
            print("onDisposed")
        }).disposed(by: disposeBag)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
    }
    
    func headerRefreshingFor(tableView: UITableView ) {
        
    }
    
    func footerRefreshingFor(tableView: UITableView) {
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RMLinkTableViewCell", for: indexPath) as! RMLinkTableViewCell
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.numberOfRowsInSection(section: section) ?? 0
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
