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

fileprivate var animationContext: UInt8 = 0


extension UIViewController: RMViewModelAction, NVActivityIndicatorViewable {
    
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
}

class RMViewController: UIViewController {
    
    var disposeBag = DisposeBag()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.animation.asObservable().subscribe(onNext: { flag in
            if flag {
                self.startAnimating()
            }else{
                self.stopAnimating()
            }
        },onDisposed: {
            self.stopAnimating()
        }).disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

