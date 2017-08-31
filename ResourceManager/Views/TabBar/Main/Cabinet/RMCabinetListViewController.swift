//
//  RMCabinetListViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 10/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import PCCWFoundationSwift

class RMCabinetTableViewCell: PFSTableViewCell {
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var cabintRoomLabel: UILabel!
    @IBOutlet weak var cabinetLocationLabel: UILabel!
    @IBOutlet weak var cabinetNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10) //if you also want to adjust separatorInset
    }
}

class RMCabinetListViewController: PFSTableViewController, RMCabinetListAction, UITableViewDataSource {
    
    @IBAction func printButtonPressed(_ sender: UIButton) {
        let point = sender.superview?.convert(sender.center, to: self.tableView)
        
        let indexPath = self.tableView.indexPathForRow(at: point!)
        
        let cabinet = self.viewModel?.elementAt(indexPath: indexPath!)
        
        let template = "<?xml version=\"1.0\" encoding=\"utf-8\" ?><Data><Print><CodeType>60-40</CodeType><Code>3121-00000600</Code><Text>站点名称:\(cabinet?.cabinetRoom ?? "")</Text><Text>服务热线:10086-8</Text><Text>机柜名称:\(cabinet?.cabinetId ?? "")</Text></Print></Data>";
        PrintServices.shared.printInView(view: self.view, template: template)

    }
    
    var viewModel: RMCabinetListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.headerRefresh(enable: true, target: self)
        
        self.tableView.footerRefresh(enable: true, target: self)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.estimatedRowHeight = 40
        
//        self.viewModel?.cabinetList(refresh: true).drive(onNext: { result in
//            self.tableView.reloadData()
//        }).disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadData(refresh: Bool) {
        self.viewModel?.cabinetList(refresh: refresh).drive(onNext: { result in
            self.tableView.reloadData()
        }, onCompleted: {
        }).disposed(by: disposeBag)
    }

    
    override func headerRefreshingFor(tableView: UITableView ) {
        tableView.mj_header.endRefreshing()
        self.reloadData(refresh: true)
    }
    
    override func footerRefreshingFor(tableView: UITableView) {
        tableView.mj_footer.endRefreshing()
        self.reloadData(refresh: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RMCabinetTableViewCell", for: indexPath) as! RMCabinetTableViewCell
        
        if let viewModel = self.viewModel {
            
            let cabinet = viewModel.elementAt(indexPath: indexPath)
                        
            cell.cabinetNameLabel.text = cabinet.cabinetCode
            
            cell.cabinetLocationLabel.text = cabinet.cabinetLocation
            cell.cabintRoomLabel.text = cabinet.cabinetRoom
            cell.capacityLabel.text = cabinet.capacity
            
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
            
            cabinetDetailViewController.viewModel = RMCabinetDetailViewModel(action: cabinetDetailViewController,
                                                                             cabinet: cabinet,
                                                                             isModify: viewModel.isModify)
            cabinetDetailViewController.delegate = self
            
        }
        
        
     }
    
    
}

extension RMCabinetListViewController: RMCabinetDetailViewControllerDelegate {
    func didEndModify() {
        self.reloadData(refresh: true)
    }
}
