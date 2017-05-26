//
//  Operators.swift
//  ResourceManager
//
//  Created by 李智慧 on 28/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

infix operator <-> : DefaultPrecedence

func nonMarkedText(_ textInput: UITextInput) -> String? {
    let start = textInput.beginningOfDocument
    let end = textInput.endOfDocument
    
    guard let rangeAll = textInput.textRange(from: start, to: end),
        let text = textInput.text(in: rangeAll) else {
            return nil
    }
    
    guard let markedTextRange = textInput.markedTextRange else {
        return text
    }
    
    guard let startRange = textInput.textRange(from: start, to: markedTextRange.start),
        let endRange = textInput.textRange(from: markedTextRange.end, to: end) else {
            return text
    }
    
    return (textInput.text(in: startRange) ?? "") + (textInput.text(in: endRange) ?? "")
}

@discardableResult
func <-> <Base: UILabel>(label: Base, variable: Variable<String>) -> Disposable {
    
    let bindToUIDisposable = variable.asObservable().bind(to: label.rx.text)
    
    let bindToVariable = label.rx.observe(String.self, "text").subscribe(onNext: { text in
        if let text = text, variable.value != text {
            variable.value = text
        }
        }, onCompleted: {
            bindToUIDisposable.dispose()
    })
    return Disposables.create(bindToUIDisposable, bindToVariable)
}

@discardableResult
func <-> <Base: UITextInput>(textInput: TextInput<Base>, variable: Variable<String>) -> Disposable {
    
    let bindToUIDisposable = variable.asObservable().bindTo(textInput.text)
    
    let bindToVariable = textInput.text
        .subscribe(onNext: {[weak base = textInput.base] n in
            guard let base = base else {
                return
            }
            
            let nonMarkedTextValue = nonMarkedText(base)
            
            /**
             In some cases `textInput.textRangeFromPosition(start, toPosition: end)` will return nil even though the underlying
             value is not nil. This appears to be an Apple bug. If it's not, and we are doing something wrong, please let us know.
             The can be reproed easily if replace bottom code with
             
             if nonMarkedTextValue != variable.value {
             variable.value = nonMarkedTextValue ?? ""
             }
             
             and you hit "Done" button on keyboard.
             */
            if let nonMarkedTextValue = nonMarkedTextValue, nonMarkedTextValue != variable.value {
                variable.value = nonMarkedTextValue
            }
            }, onCompleted: {
                bindToUIDisposable.dispose()
        })
    
    return Disposables.create(bindToUIDisposable, bindToVariable)
}

@discardableResult
func <-> (text: ControlProperty<String?>, variable: Variable<String>) -> Disposable {
    
    let bindToUIDisposable = variable.asObservable().bindTo(text)
    
    let bindToVariable = text
        .subscribe(onNext: { text in
            /**
             In some cases `textInput.textRangeFromPosition(start, toPosition: end)` will return nil even though the underlying
             value is not nil. This appears to be an Apple bug. If it's not, and we are doing something wrong, please let us know.
             The can be reproed easily if replace bottom code with
             
             if nonMarkedTextValue != variable.value {
             variable.value = nonMarkedTextValue ?? ""
             }
             
             and you hit "Done" button on keyboard.
             */
            
            let c = text
            
            
            if   c != variable.value {
                variable.value = text!
            }
            }, onCompleted: {
                bindToUIDisposable.dispose()
        })
    
    return Disposables.create(bindToUIDisposable, bindToVariable)
}



