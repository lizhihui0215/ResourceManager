//
//  RMViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 22/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import NVActivityIndicatorView
import Toaster

fileprivate var animationContext: UInt8 = 0


extension UIViewController: RMViewModelAction {
    

    func showMessage(message: String, success: Bool) -> Driver<Bool> {
        return Observable.create{
            [weak self] observer in
            let alertView = UIAlertController(title: "", message: message, preferredStyle: .alert)
            observer.on(.next(success))
            
            alertView.addAction(UIAlertAction(title: "OK", style: .cancel) { action in
                observer.on(.completed)
            })
            
            self?.present(alertView, animated: true, completion: nil)
            return Disposables.create{
                alertView.dismiss(animated: true, completion: nil)
            }
            }.asDriver(onErrorJustReturn: true)
    }

    
    var animation: Variable<Bool> {
        if let animation = objc_getAssociatedObject(self, &animationContext) as? Variable<Bool> {
            return animation
        }
        
        let animation = Variable(false)
        
        objc_setAssociatedObject(self, &animationContext, animation, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return animation
    }
    
    internal func showErrorAlert(_ message: String, cancelAction: String?) -> Driver<Bool> {
        return Observable.create{
            [weak self] observer in
            self?.animation.value = false
            let alertView = UIAlertController(title: "", message: message, preferredStyle: .alert)
            
            alertView.addAction(UIAlertAction(title: cancelAction ?? "OK", style: .cancel) { action in
                observer.on(.completed)
            })
            
            self?.present(alertView, animated: true, completion: nil)
            return Disposables.create{
                alertView.dismiss(animated: true, completion: nil)
            }
            }.asDriver(onErrorJustReturn: false)
    }
    
    
    func toast(message: String) -> Driver<Bool> {
        return Observable.create{ observer in
            let toast = Toast(text: message, duration: 0.5)
            toast.show()
            return Disposables.create{
                toast.cancel()
            }
            }.asDriver(onErrorJustReturn: false)
    }
    
}

class RMViewController: UIViewController {
    
//    var disposeBag = DisposeBag()
   
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.animation.asObservable().subscribe(onNext: {[weak self] flag in
//            if let strongSelf = self ,flag {
//                strongSelf.startAnimating()
//            }else if let strongSelf = self{
//                strongSelf.stopAnimating()
//            }
//        },onDisposed: {[weak self] in
//            if let strongSelf = self {
//                strongSelf.stopAnimating()
//            }
//        }).disposed(by: disposeBag)
        
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(RMViewController.backgroundTapped))
//        self.view.addGestureRecognizer(tap)
//        
//        tap.cancelsTouchesInView = false
        
//    }
    
//    func backgroundTapped()  {
//        self.view.endEditing(true)
//    }
    
    
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
}

