//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by 전현성 on 2022/12/14.
//  Copyright © 2022 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MenuListViewModel {
    var menuObservable = BehaviorRelay<[Menu]>(value: [])
    
    lazy var itemsCount = menuObservable.map {
        $0.map { $0.count }.reduce(0, +)
    }
    
    lazy var totalPrice = menuObservable.map {
        $0.map { $0.price * $0.count }.reduce(0, +)
    }
    
    init() {
        APIService.fetchAllMenusRx()
            .map { data -> [MenuItem] in
                struct Response: Decodable {
                    let menus: [MenuItem]
                }
                let response = try! JSONDecoder().decode(Response.self, from: data)
                
                return response.menus
            }
            .map { menuItems -> [Menu] in
                var menus: [Menu] = []
                menuItems.enumerated().forEach { index, item in
                    menus.append(Menu.fromMenuItems(id: index, item: item))
                }
                
                return menus
            }
            .take(1)
            .bind(to: menuObservable)
    }
    
    func clearAllItemSelections() {
        menuObservable.map {
            $0.map { Menu(id: $0.id, name: $0.name, price: $0.price, count: 0) }
        }
        .take(1)
        .subscribe(onNext: {
            self.menuObservable.accept($0)
        })
    }
    
    func changeMenuCount(item: Menu, increase: Int) {
        menuObservable.map { menus in
            menus.map { m in
                if m.id == item.id {
                    return Menu(id: m.id, name: m.name, price: m.price, count: max(m.count + increase, 0))
                } else {
                    return Menu(id: m.id, name: m.name, price: m.price, count: m.count)
                }
            }
        }
        .take(1)
        .subscribe(onNext: {
            self.menuObservable.accept($0)
        })
    }
    
    func onOrder() {
        
    }
}
