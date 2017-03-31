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

class RMTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
}


class RMTableViewController: RMViewController {
    @IBOutlet var tableViews: [UITableView]!
    
    var tableView: UITableView {
        return tableViews[0]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let items = Observable.just([1,2,3,4])
        
        items.bindTo(tableView.rx.items){ (xxx, row, element) in
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
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

extension RMTableViewController: UITableViewDataSource {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RMTableViewCell
        
        
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
