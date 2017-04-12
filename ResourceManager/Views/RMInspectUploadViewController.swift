//
//  RMInspectUploadViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 12/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import RSKGrowingTextView
import RxSwift
import TZImagePickerController
import RxCocoa
import Photos

class RMInspectUploadCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }

}

//extension UICollectionView: ReactiveCompatible{
//    
//}

class RMInspectUploadViewController: RMViewController, UICollectionViewDataSource, UICollectionViewDelegate, TZImagePickerControllerDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "RMInspectUploadCell", for: indexPath) as! RMInspectUploadCell
        
        cell.deleteButton.isHidden = self.viewModel.elementAt(indexPath: indexPath).isPlus
        
        let tap = cell.deleteButton.rx.tap
        
        tap.subscribe {[weak self] x in
            
            if let strongSelf = self {
                strongSelf.viewModel.removeAt(indexPath: indexPath)
                strongSelf.collectionView.reloadData()
            }
            
        }.disposed(by: cell.disposeBag)
        
        cell.imageView.image = self.viewModel.elementAt(indexPath: indexPath).image
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = self.viewModel.numberOfRowsInSection(section: section)
        
        return  count > 9 ? 9 : count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageItem = self.viewModel.elementAt(indexPath: indexPath)
        
        if imageItem.isPlus {
   
            let limit = 10 - self.viewModel.section(at: 0).items.count
            
            let imagePicker = TZImagePickerController(maxImagesCount: limit, delegate: self)

            self.present(imagePicker!, animated: true, completion: nil)
            
            imagePicker?.didFinishPickingPhotosHandle = { (images,xx,ee ) in
                for image in images! {
                    let sectionItem = RMSectionItem(item: RMImageItem(image: image))
                    
                    self.viewModel.section(at: 0).items.insert(sectionItem, at: 0)
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    
    
    @IBOutlet weak var verticalLayoutConstraint: NSLayoutConstraint!

    @IBOutlet weak var textView: RSKGrowingTextView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = RMInspectUploadViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { (x) in
            self.verticalLayoutConstraint.constant = (x?.height)!
        }).disposed(by: disposeBag)
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
    
    deinit {
    }

}
