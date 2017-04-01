//
//  RMListViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 01/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import RxSwift
import RxRealm
import RealmSwift
import RxCocoa

class RMSectionItem<T> {
    var isSelected: Bool
    var item: T
    
    init(isSelected: Bool = false, item: T) {
        self.isSelected = isSelected
        self.item = item
    }
}

class RMSection<Element, Item> {
    var item: Item?
    var isOpen: Bool
    var items: [RMSectionItem<Element>]
    
    init(item: Item?, isOpen: Bool? = false, items: [RMSectionItem<Element>]) {
        self.item = item
        self.isOpen = isOpen!
        self.items = items
    }
}

protocol RMListDataSource {
    associatedtype Element
    associatedtype SectionItem
    
    var datasource: Array<RMSection<Self.Element, Self.SectionItem>> {get set}
    
    func elementAt(indexPath: NSIndexPath) -> Self.Element
}

extension RMListDataSource {
    
    func sectionItem(at: Int) -> SectionItem? {
        return self.section(at: at).item
    }
    
    func section(at: Int) -> RMSection<Self.Element, Self.SectionItem> {
        return self.datasource[at]
    }

    func elementAt(indexPath: NSIndexPath) -> Element {
       return self.section(at: indexPath.section).items[indexPath.row].item
    }
    
    func elementOf(selected: Bool, at section: Int) -> [Self.Element] {
        return self.section(at: section).items.filter { $0.isSelected == selected }.map{ $0.item }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return self.section(at: section).items.count
    }
    
    func numberOfSection() -> Int {
        return self.datasource.count
    }

}

class RMListViewModel: RMViewModel, RMListDataSource {
    
    private var _datasource = [RMSection<RMUser, String>]()
    
    var datasource: Array<RMSection<RMUser, String>> {
        set {
            _datasource = newValue
        }
        
        get{
           return _datasource
        }
    }
}
