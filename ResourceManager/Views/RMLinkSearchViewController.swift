//
//  RMLinkSearchViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 29/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit


class RMLinkSearchViewController: RMViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var linkStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

    }
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        let linkNode = RMLinkNodeView()

        linkStackView.addArrangedSubview(linkNode)
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        let view = linkStackView.arrangedSubviews[0]
        linkStackView.removeArrangedSubview(view)
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
