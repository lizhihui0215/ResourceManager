//
//  RMCabinetListViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 10/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
class RMCabinetTableViewCell: RMTableViewCell {
    @IBOutlet weak var cabinetCodeLabel: UILabel!
    
    @IBOutlet weak var cabinetLocationLabel: UILabel!
    @IBOutlet weak var cabinetNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10) //if you also want to adjust separatorInset
    }
}

class RMCabinetListViewController: RMTableViewController, RMCabinetListAction, UITableViewDataSource {
    
    var viewModel: RMCabinetListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.headerRefresh(enable: true, target: self)
        
        self.tableView.footerRefresh(enable: true, target: self)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.estimatedRowHeight = 40
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func headerRefreshingFor(tableView: UITableView ) {
        self.viewModel?.cabinetList(refresh: true).drive(onNext: { result in
            self.tableView.reloadData()
        }, onCompleted: {
            tableView.mj_header.endRefreshing()
        }).disposed(by: disposeBag)
    }
    
    override func footerRefreshingFor(tableView: UITableView) {
        self.viewModel?.cabinetList(refresh: false).drive(onNext: { result in
            self.tableView.reloadData()
        }, onCompleted: {
            tableView.mj_footer.endRefreshing()
        }).disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RMCabinetTableViewCell", for: indexPath) as! RMCabinetTableViewCell
        
        if let viewModel = self.viewModel {
            
            let cabinet = viewModel.elementAt(indexPath: indexPath)
            
            cell.cabinetCodeLabel.text = cabinet.cabinetCode
            
            cell.cabinetNameLabel.text = cabinet.cabinetName
            
            cell.cabinetLocationLabel.text = cabinet.cabinetLocation
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.numberOfRowsInSection(section: section) ?? 0
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        let cabinetDetailViewController = segue.destination as! RMCabinetDetailViewController
        
        if let viewModel = self.viewModel {
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            
            let cabinet = viewModel.elementAt(indexPath: indexPath!)
            
            cabinetDetailViewController.viewModel = RMCabinetDetailViewModel(cabinet: cabinet)
            
        }
        
        
     }
    
    
}
