//
//  RMLocationViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/12.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import UIKit
import AddressBook

class RMLocationCell: RMTableViewCell {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
}

class RMLocationViewController: RMTableViewController, UITableViewDataSource, RMLocationAction {
    
    
    var viewModel: RMLocationViewModel?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.estimatedRowHeight = 40
        
        self.viewModel?.start()
        
        self.searchBar.rx.searchButtonClicked.asObservable().subscribe(onNext: {[weak self] _ in
            if let strongSelf = self {
                strongSelf.viewModel?.start(query: strongSelf.searchBar.text ?? "")
                strongSelf.searchBar.resignFirstResponder()
            }
        }).disposed(by: disposeBag)
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
            
            if let addrList = mapItem.placemark.addressDictionary?["FormattedAddressLines"] as? [String]
            {
                cell.addressLabel.text = addrList.joined(separator: " ")
            }
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
