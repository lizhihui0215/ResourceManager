//
//  RMLocationViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/12.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import UIKit
import AddressBook
import MapKit

import UIKit
import AddressBook
import MapKit
import PCCWFoundationSwift

class RMLocationCell: PFSTableViewCell {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
}

protocol RMLocationViewControllerDelegate {
    func didEndSelected(mapItem: AMapPOI, of locationViewController: RMLocationViewController)
}

extension RMLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate, let viewModel = viewModel {
            let mapItem = viewModel.elementAt(indexPath: indexPath)
            delegate.didEndSelected(mapItem: mapItem, of: self)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

class RMLocationViewController: PFSTableViewController, UITableViewDataSource, RMLocationAction {
    
    
    var viewModel: RMLocationViewModel?
    
    var delegate: RMLocationViewControllerDelegate?
    
    var query: String {
        get {
            return "路|园|街道|餐厅|店|公司"
        }
    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.estimatedRowHeight = 40
        
        self.tableView.headerRefresh(enable: true, target: self)
        
        self.tableView.footerRefresh(enable: true, target: self)
        
        self.tableView.mj_header.beginRefreshing()
        
        self.searchBar.rx.searchButtonClicked.asObservable().subscribe(onNext: {[weak self] _ in
            if let strongSelf = self {
                strongSelf.tableView.mj_header.beginRefreshing()
                strongSelf.searchBar.resignFirstResponder()
            }
        }).disposed(by: disposeBag)
    }
    
    override func headerRefreshingFor(tableView: UITableView) {
        if let viewModel = self.viewModel {
            viewModel.start(query: self.searchBar.text ?? query, isRefresh: true, completionHandler: {
                tableView.reloadData()
                tableView.mj_header.endRefreshing()
            })
        }
    }
    
    override func footerRefreshingFor(tableView: UITableView) {
        if let viewModel = self.viewModel {
            viewModel.start(query: self.searchBar.text ?? query, isRefresh: false, completionHandler: {
                tableView.reloadData()
                tableView.mj_footer.endRefreshing()
            })
        }
    }
    
    
    func reload() {
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RMLocationCell", for: indexPath) as! RMLocationCell
        
        if let viewModel = self.viewModel {
            let mapItem = viewModel.elementAt(indexPath: indexPath)
            
            cell.nameLabel.text = mapItem.name
            cell.addressLabel.text =  mapItem.address
        }
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.numberOfRowsInSection(section: section) ?? 0
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
