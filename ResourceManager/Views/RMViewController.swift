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

extension UIViewController: RMViewModelAction {
    internal func showErrorAlert(_ message: String, cancelAction: String?) -> Driver<Bool> {
        return Observable.create{
            observer in
            let alertView = UIAlertController(title: "", message: message, preferredStyle: .alert)
            
            alertView.addAction(UIAlertAction(title: cancelAction ?? "OK", style: .cancel) { action in
//                observer.on(.next(false))
                
                observer.on(.completed)
            })
            
            self.present(alertView, animated: true, completion: nil)
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

