//
//  MenuDB.swift
//  GroupOrdersEricApp1
//
//  Created by user on 2020/8/26.
//  Copyright © 2020 user. All rights reserved.
//

import Foundation

// 以下定義的 struct 結構 是要抓取 Menu.plist 的架構資料
struct Item : Decodable {
    let drink : String
    let option : [Option]
    
    struct Option : Decodable {
        let size : String
        let price : Int
    }
}
// 以下為將 Menu.plist 的資料抓取出來後 放入 [Item] 陣列  以便作為 飲料清單。這些程式碼的架構都很制式，咱們參考這樣的想法並作為後續的調整運用
internal struct MenuDBController {
    internal static let shared = MenuDBController ()
    func getMenuData(completion : @escaping([Item]?) -> ()) {
        let url = Bundle.main.url(forResource: "Menu", withExtension: "plist")!
        
        if let data = try? Data(contentsOf: url), let menuItem = try? PropertyListDecoder().decode([Item].self, from: data){
            completion(menuItem)
        }else{
            completion(nil)
        }
     
        
    }
    
    
    
    
    
}

