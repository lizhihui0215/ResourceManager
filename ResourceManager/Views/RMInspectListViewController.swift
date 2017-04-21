//
//  RMInspectListViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 11/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit

class RMInspectListCell: RMTableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
}

class RMInspectListViewController: RMTableViewController,UITableViewDataSource,RMInpsectListAction {
    
    var viewModel: RMInspectListViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.headerRefresh(enable: true, target: self)
        
        self.tableView.footerRefresh(enable: true, target: self)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.estimatedRowHeight = 40
        self.viewModel?.inspectList(refresh: true).drive(onNext: { result in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)


        // Do any additional setup after loading the view.
    }
    
    override func headerRefreshingFor(tableView: UITableView ) {
        tableView.mj_header.endRefreshing()
        self.viewModel?.inspectList(refresh: true).drive(onNext: { result in
            self.tableView.reloadData()
        }, onCompleted: {
        }).disposed(by: disposeBag)
    }
    
    override func footerRefreshingFor(tableView: UITableView) {
        tableView.mj_footer.endRefreshing()
        self.viewModel?.inspectList(refresh: false).drive(onNext: { result in
            self.tableView.reloadData()
        }, onCompleted: {
        }).disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RMInspectListCell", for: indexPath) as! RMInspectListCell
        
        if let viewModel = self.viewModel {
            let inspect = viewModel.elementAt(indexPath: indexPath)
            cell.titleLabel.text = inspect.locationName
            cell.contentLabel.text = inspect.reportContent
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.numberOfRowsInSection(section: section) ?? 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using 
        let inspectViewController = segue.destination as! RMInspectPhotoViewController
        
        if let viewModel = self.viewModel {
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            
            let inspect = viewModel.elementAt(indexPath: indexPath!)
            
            let viewModel = RMInspectPhotoViewModel(pictures: (inspect.pictures?.toArray())!, caption: inspect.reportContent)
            inspectViewController.viewModel = viewModel
        }
    }

}
