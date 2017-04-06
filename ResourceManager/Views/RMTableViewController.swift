//
//  RMTableViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 31/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MJRefresh


class RMTableViewCell: UITableViewCell {
    
    private(set) var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag() // because life cicle of every cell ends on prepare for reuse
    }
    
}

class RMTableViewController: RMViewController, RMTableViewRefresh {
    
    @IBOutlet var tableViews: [UITableView]!
        
    var tableView: UITableView {
        return tableViews[0]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.emptyFooterView()
    }
    
    func emptyFooterView()  {
        for tableView in self.tableViews {
            tableView.tableFooterView = UIView()
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 40
        }
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


protocol RMTableViewRefresh {
    func headerRefreshingFor(tableView: UITableView)
    
    func footerRefreshingFor(tableView: UITableView)
}

extension RMTableViewRefresh {
    func footerRefreshingFor(tableView: UITableView) {}
    
    func headerRefreshingFor(tableView: UITableView) {}
}

extension UITableView {
    func headerRefresh(enable: Bool,target: RMTableViewRefresh)  {
        if enable {
            self.mj_header = MJRefreshNormalHeader(refreshingBlock: {
                target.headerRefreshingFor(tableView: self)
            })
        }else{
            self.mj_header = nil
        }
    }
    
    func footerRefresh(enable: Bool, target: RMTableViewRefresh) {
        if enable {
            
            self.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
                target.footerRefreshingFor(tableView: self)
            })
        }else{
            self.mj_footer = nil
        }
    }
}
