//
//  RMInspectUploadViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 12/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import RxSwift
import TZImagePickerController
import RxCocoa
import Photos
import MapKit
import RSKGrowingTextView
import PCCWFoundationSwift

protocol RMInspectUploadViewControllerDelegate {
    func inspectUpload(viewController: RMInspectUploadViewController, didEndCommit success: Bool);
}

class RMInspectUploadCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
}

extension RMInspectUploadViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 3) / CGFloat(3.0)
        return CGSize(width: width, height: width)
    }
}

extension RMInspectUploadViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "RMInspectUploadCell", for: indexPath) as! RMInspectUploadCell
        
        cell.deleteButton.isHidden = (self.viewModel?.elementAt(indexPath: indexPath).isPlus)!
        
        let tap = cell.deleteButton.rx.tap
        
        tap.subscribe {[weak self] x in
            
            if let strongSelf = self {
                strongSelf.viewModel?.removeAt(indexPath: indexPath)
                strongSelf.collectionView.reloadData()
            }
            
            }.disposed(by: cell.disposeBag)
        
        cell.imageView.image = self.viewModel?.elementAt(indexPath: indexPath).image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = self.viewModel?.numberOfRowsInSection(section: section)
        
        return  count! > 9 ? 9 : count!
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageItem = self.viewModel?.elementAt(indexPath: indexPath)
        
        if (imageItem?.isPlus)! {
            
            let limit = 10 - (self.viewModel?.section(at: 0).items.count)!
            
            let imagePicker = TZImagePickerController(maxImagesCount: limit, delegate: self)
            
            imagePicker?.naviBgColor = UIColor(hex6: 0x222960)
            
            imagePicker?.naviTitleColor = UIColor.white
            
            self.present(imagePicker!, animated: true, completion: nil)
            
            imagePicker?.didFinishPickingPhotosHandle = { (images,xx,ee ) in
                for image in images! {
                    let sectionItem = RMSectionItem(item: RMImageItem(image: image))
                    
                    self.viewModel?.section(at: 0).items.insert(sectionItem, at: 0)
                }
                self.collectionView.reloadData()
            }
        }
    }
}

extension RMInspectUploadViewController: RMScanViewControllerDelegate{
    func scaned(result: Any, of scanViewController: RMScanViewController) {
        let cabinet = result as! RMCabinet
        
        self.viewModel?.cabinetRoom.value = cabinet.cabinetRoom!
        
        self.viewModel?.resourceId.value = cabinet.cabinetCode!
        
    }

   
}

extension RMInspectUploadViewController: RMInspectUploadAction {
    
}

extension RMInspectUploadViewController: RMLocationViewControllerDelegate {
    func didEndSelected(mapItem: AMapPOI, of locationViewController: RMLocationViewController) {
        if let viewModel = viewModel
        {
            viewModel.locationName.value =   mapItem.name
            viewModel.longitude.value = CLLocationDegrees(mapItem.location.latitude)
            viewModel.latitude.value = CLLocationDegrees(mapItem.location.longitude)
            self.locationLabel.text = viewModel.locationName.value
        }
    }
}

class RMInspectUploadViewController: RMViewController, UICollectionViewDelegate, TZImagePickerControllerDelegate {
    // 站点名称
    @IBOutlet weak var cabinetRoomTextField: UITextField!
    // 机柜名称
    @IBOutlet weak var resourceIdTextField : UITextField!
    
    @IBOutlet weak var verticalLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textView: RSKGrowingTextView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    var delegate: RMInspectUploadViewControllerDelegate?
    
    var viewModel: RMInspectUploadViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = RMInspectUploadViewModel(action: self)
        
        textView.rx.textInput <-> (self.viewModel?.reportContent)!
        
        
        cabinetRoomTextField.rx.textInput <-> (self.viewModel?.cabinetRoom)!
        resourceIdTextField.rx.textInput <-> (self.viewModel?.resourceId )!
        
        self.textView.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        
        self.collectionView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { (x) in
            self.verticalLayoutConstraint.constant = (x?.height)!
        }).disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func locationTapped(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "toLocation", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resourceTapped(_ sender: UITapGestureRecognizer) {
        self.presentPicker(items: (self.viewModel?.resourceTypes())!) { (resourceType) in
//            self.resourceTypeLabel.text = resourceType.title
//            self.viewModel?.resourceType.value = resourceType.type.rawValue
        }
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        self.viewModel?.upload().drive(onNext: { success in
            if let delegate = self.delegate {
                delegate.inspectUpload(viewController: self, didEndCommit: success)
            }
        }).disposed(by: disposeBag)
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toLocation" {
            let locationViewController = segue.destination as! RMLocationViewController
            locationViewController.viewModel = RMLocationViewModel(action: locationViewController)
            locationViewController.delegate = self
        }else if segue.identifier == "toScan" {
            let scanViewConntroller = segue.destination as! RMScanViewController
            scanViewConntroller.viewModel = RMUploadScanViewModel(action: scanViewConntroller)
            scanViewConntroller.delegate = self
        }
    }
    
    
    deinit {
    }
    
}
