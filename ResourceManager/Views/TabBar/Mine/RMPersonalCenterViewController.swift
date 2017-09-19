//
//  RMPersonalCenterViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/16.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import UIKit
import PCCWFoundationSwift

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
        return self.viewModel!.numberOfRowsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RMPersonalCenterCell", for: indexPath) as! RMPersonalCenterCell
        
        cell.titleLabel.text = self.viewModel?.elementAt(indexPath: indexPath).title()
        cell.imageView.image = self.viewModel?.elementAt(indexPath: indexPath).image()
        
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
        
        cell.imageView.image = self.viewModel?.elementAt(indexPath: indexPath).selectedImage()
        
        cell.titleLabel.textColor = UIColor(hex6: 0x2D97D4, alpha: 1)
        
        
        let identifier = self.viewModel?.elementAt(indexPath: indexPath).idenfitier()
        
        self.performSegue(withIdentifier: identifier!, sender: indexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        
        let cell = collectionView.cellForItem(at: indexPath) as! RMPersonalCenterCell
        
        cell.imageView.image = self.viewModel?.elementAt(indexPath: indexPath).image()
        
        cell.titleLabel.textColor = UIColor(hex6: 0x1E2960, alpha: 1)
    }
    
}


extension RMPersonalCenterViewController: RMPersonalCenterViewAction {
    
}

class RMPersonalCenterViewController: PFSViewController {

    var viewModel: RMPersonalCenterViewModel?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = RMPersonalCenterViewModel(action: self)
        
        self.viewModel?.loginUser().drive(onNext: {[weak self] _ in
            if let viewModel = self?.viewModel {
                self?.phoneLabel.text = viewModel.user?.mobile
                self?.accountLabel.text = viewModel.user?.loginName
                if let avatar = viewModel.user?.avatar {
                    let url = URL(string: avatar)
                    self?.avatarImageView.kf.setImage(with: url)
                }
            }
        }).disposed(by: disposeBag)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        self.viewModel?.logout()
        self.performSegue(withIdentifier: "toLogin", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toExchangePassword" {
           let exchangePasswordViewController = segue.destination as! RMExchangePasswordViewController
            
            exchangePasswordViewController.viewModel = RMExchangePasswordViewModel(action: exchangePasswordViewController, user: (self.viewModel?.user!)!)
        } else if segue.identifier == "toSuggest" {
            let suggestViewController = segue.destination as! RMSuggestViewController
            
            suggestViewController.viewModel = RMSuggestViewModel(action: suggestViewController)
        }
    }
    

}
