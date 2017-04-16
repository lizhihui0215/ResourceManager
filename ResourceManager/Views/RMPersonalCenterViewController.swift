//
//  RMPersonalCenterViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/16.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import UIKit

class RMPersonalCenterCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
}

extension RMPersonalCenterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30.0) / 2.0
        
        return CGSize(width: width, height: width)
    }
    
}

extension RMPersonalCenterViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RMPersonalCenterCell", for: indexPath) as! RMPersonalCenterCell
        
        cell.titleLabel.text = self.viewModel.elementAt(indexPath: indexPath).title()
        cell.imageView.image = self.viewModel.elementAt(indexPath: indexPath).image()
        
        cell.selectedBackgroundView = {
            let view = UIView()
            view.backgroundColor = UIColor(hex6: 0x1E295E, alpha: 1)
            return view
        }()
        
        cell.backgroundView = UIImageView(image: UIImage(named: "resource-manager.cell.background"))
        
        return cell
    }
}

extension RMPersonalCenterViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let cell = collectionView.cellForItem(at: indexPath) as! RMPersonalCenterCell
        
        cell.imageView.image = self.viewModel.elementAt(indexPath: indexPath).selectedImage()
        
        cell.titleLabel.textColor = UIColor(hex6: 0x2D97D4, alpha: 1)
        
        
        let identifier = self.viewModel.elementAt(indexPath: indexPath).idenfitier()
        
        self.performSegue(withIdentifier: identifier, sender: indexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        
        let cell = collectionView.cellForItem(at: indexPath) as! RMPersonalCenterCell
        
        cell.imageView.image = self.viewModel.elementAt(indexPath: indexPath).image()
        
        cell.titleLabel.textColor = UIColor(hex6: 0x1E2960, alpha: 1)
    }
    
}


class RMPersonalCenterViewController: RMViewController {

    var viewModel: RMPersonalCenterViewModel = RMPersonalCenterViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
