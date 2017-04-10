//
//  RMResourceManagerViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 29/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit

class RMResourceManagerCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
}

class RMResourceManagerViewController: RMViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var viewModel = RMResourceManagerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RMResourceManagerCell", for: indexPath) as! RMResourceManagerCell
        
        cell.titleLabel.text = self.viewModel.elementAt(indexPath: indexPath).title()
        cell.imageView.image = self.viewModel.elementAt(indexPath: indexPath).image()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
       let identifier = self.viewModel.elementAt(indexPath: indexPath).idenfitier()
        
        self.performSegue(withIdentifier: identifier, sender: indexPath)

    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        let item = self.viewModel.elementAt(indexPath: sender as! IndexPath)
        
        switch item {
        case .linkSearch:
            let searchViewController = segue.destination as! RMLinkSearchViewController
            searchViewController.viewModel = RMLinkSearchViewModel(actions: searchViewController)
            
        case .cabinetSearch:
            let searchViewController = segue.destination as! RMLinkSearchViewController
            searchViewController.viewModel = RMCabinetSearchViewModel(actions: searchViewController)
        case .linkModify:
            print("")
        case .inspect:
            break
        }
        
    }
    

}
