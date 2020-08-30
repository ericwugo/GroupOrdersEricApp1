//
//  SheetDB.swift
//  GroupOrdersEricApp1
//
//  Created by user on 2020/8/26.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
// 以下所定義的欄位 都是在 Google sheet 中先定義好的 excel 欄位
struct Order: Codable {
    var id: String
    var name: String
    var item: String
    var sugar: String
    var ice: String
    var size: String
    var mixin: String?
    var price: String
    var comment: String?
    // 以下是給初始值的定義方式
    init() {
        id = "INCREMENT"
        name = ""
        item = ""
        sugar = ""
        ice = ""
        size = ""
        price = ""
    }
}
// 以下  配合rawValue定義enum的值，可以讓enum自帶有意義的資訊 ** enum 最常的運用 將與 switch 搭配
enum SugarLevel: String {
    case normal = "全糖"
    case seventy = "少糖"
    case half = "半糖"
    case thirty = "微糖"
    case zero = "無糖"
}

enum IceLevel: String {
    case full = "正常"
    case less = "少冰"
    case no = "去冰"
    case zero = "完全去冰"
    case hot = "熱飲"
}

enum SizeLevel: String {
    case big = "大杯"
    case medium = "中杯"
}


// https://sheetdb.io/api/v1/pya0uqlflbygl  Ericwu ap1





// 以下所寫的 struct SheetDBController 有 4 種 func 是 搭配 Google sheet API 進行 資料的各項異動，請注意日後程式碼的搭配應用！！！
internal struct SheetDBController {
    internal static let shared = SheetDBController()
    
    // MARK: - GET
    // 取得 Google sheet 上面訂單的資料 放入Order list 中
    func getData(completion: @escaping([Order]?) -> ()) {
        let urlStr = "https://sheetdb.io/api/v1/pya0uqlflbygl"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let data = data, let sheetData = try? JSONDecoder().decode([Order].self, from: data) {
                    completion(sheetData)
//                    print(sheetData)
                } else {
                    completion(nil)
                }
            }.resume()
        }

    }
    
    
    //MARK: - POST
    // 以下是新增訂單時。將資料 post 到 Google sheet 內的程式碼
    func postData(newOrder: Order, completion: @escaping() -> ()) {
        let urlStr = "https://sheetdb.io/api/v1/pya0uqlflbygl"

        if let url = URL(string: urlStr) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let postData = ["data":newOrder]
            
            if let data = try? JSONEncoder().encode(postData) {
                
                // Decode the return response from API to know if it is successful or failed
                URLSession.shared.uploadTask(with: request, from: data) { returnData, response, error in
//                    print("return data: \(returnData)")
//                    print("response: \(response)")
//                    print("errer: \(error)")
                    if let returnData = returnData, let dic = try? JSONDecoder().decode([String: Int].self, from: returnData), dic["created"] == 1 {
                        print("Post succeeded")
                        completion()
                    } else {
                        print("Post failed")
                    }

                }.resume()
                
            }
        }
    }
    
    //MARK: - PUT
    // 以下是資料有異動更新時，將資料 update 到 Google sheet 的程式碼
    func putData(updatedOrder: Order, DBID: String, completion: @escaping () -> ()) {
        let urlStr = "https://sheetdb.io/api/v1/pya0uqlflbygl/id/\(DBID)"
        if let url = URL(string: urlStr) {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            
            let putData = ["data":updatedOrder]
            if let data = try? JSONEncoder().encode(putData) {
                URLSession.shared.uploadTask(with: request, from: data) { returnData, response, error in
                    
//                    print("return data: \(returnData)")
//                    print("response: \(response)")
//                    print("errer: \(error)")
                    
                    if let returnData = returnData, let dic = try? JSONDecoder().decode([String: Int].self, from: returnData), dic["updated"] == 1 {
                        print("Put succeeded")
                        completion()
                    } else {
                        print("Put failed")
                    }
                }.resume()
            }
        }
        
    }
    
    // MARK: - DELETE
    // 以下是刪除資料時，將 Google sheet 的資料同步刪除
    func deleteData(DBno: String) {
        let urlStr = "https://sheetdb.io/api/v1/pya0uqlflbygl/id/\(DBno)"
        if let url = URL(string: urlStr) {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { returnData, response, error in
                if let returnData = returnData, let dic = try? JSONDecoder().decode([String: Int].self, from: returnData), dic["deleted"] == 1 {
                    print("Delete succeeded")
                } else {
                    print("Delete failed")
                }
            }.resume()

        }

    }
    
    
    
    // MARK: - Test API data
//    func testGetData(completion: ([Order]?) -> ()) {
//        guard let data = NSDataAsset(name: "sheetDB2")?.data else {
//           print("data not exist")
//           return
//        }
//        do {
//           let decoder = JSONDecoder()
//           let result = try decoder.decode([Order].self, from: data)
//            completion(result)
//           print(result)
//        } catch  {
//            completion(nil)
//           print(error)
//        }
//    }

    
}


