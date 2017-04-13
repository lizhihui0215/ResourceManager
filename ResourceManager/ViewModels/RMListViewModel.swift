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
    
    @discardableResult
    func append(item: Element, isSelected: Bool? = false) -> Element {
        self.items.append(RMSectionItem(isSelected: isSelected!, item: item))
        return item
    }
    
    @discardableResult
    func append(contentsOf contents: [RMSectionItem<Element>]) -> [RMSectionItem<Element>] {
        self.items.append(contentsOf: contents)
        return contents
    }
    
    @discardableResult
    func append(contentsOf contents: [Element]) -> [RMSectionItem<Element>] {
        
        var sectionItems = [RMSectionItem<Element>]()
        
        for element in contents {
            sectionItems.append(RMSectionItem(isSelected: false, item: element))
        }
        
        self.items.append(contentsOf: sectionItems)
        
        return sectionItems
    }
    
    func removeAll()  {
        self.items.removeAll()
    }
    

    
    init(item: Item? = nil, isOpen: Bool? = false, items: [RMSectionItem<Element>]? = []) {
        self.item = item
        self.isOpen = isOpen!
        self.items = items!
    }
}

protocol RMListDataSource {
    associatedtype Element
    associatedtype SectionItem
    
    var datasource: Array<RMSection<Self.Element, Self.SectionItem>> {get set}
    
    func elementAt(indexPath: IndexPath) -> Self.Element
}


extension RMListDataSource {
    @discardableResult
    func sectionItem(at: Int) -> SectionItem? {
        return self.section(at: at).item
    }
    
    @discardableResult
    func section(at: Int) -> RMSection<Self.Element, Self.SectionItem> {
        return self.datasource[at]
    }
    
    @discardableResult
    func elementAt(indexPath: IndexPath) -> Element {
        return self.section(at: indexPath.section).items[indexPath.row].item
    }
    
    func removeAt(indexPath: IndexPath) -> Void {
        self.section(at: indexPath.section).items.remove(at: indexPath.row)
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


