//
//  OrdersVC.swift
//  GroupOrdersEricApp1
//
//  Created by user on 2020/8/28.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class OrdersVC: UIViewController {
    
    // 抓取 訂單 資料 ，以下所有程式都是以 Order 陣列內的資料計算在跑
    var orders = [Order]()
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var numberOfTotalItemLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabelOutlet: UILabel!
    
    
    // 以下為計算訂單總杯數 與 總金額 的程式。簡單明瞭 ！真厲害 ！
    func updateTotalOrderInfo() {
        numberOfTotalItemLabel.text = String(orders.count)
        var totalPrice = 0
        for i in 0 ..< orders.count {
            totalPrice += Int(orders[i].price)!
        }
        totalPriceLabelOutlet.text = String(totalPrice)
    }
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // 畫面一啟動。先抓取訂單的總筆數 ！
        numberOfTotalItemLabel.text = String(orders.count)

        // Do any additional setup after loading the view.
    }
    
    // 這是 unwind func 返回此畫面的程式
    @IBAction func unwindToOrderVC(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    
    
// 以下為 prepare func 當執行任何 Segue 時都會同時觸發 prepare func
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVC = segue.destination as! FormVC
            let sender = sender as! Int
            
            destinationVC.isNewOrder = false
            
            let selectedItem = orders[sender]

            destinationVC.newOrder.id = selectedItem.id
            destinationVC.name = selectedItem.name
            destinationVC.item = selectedItem.item
            destinationVC.price = selectedItem.mixin == "" ? selectedItem.price : String(Int(selectedItem.price)! - 10)
            
            destinationVC.comment = selectedItem.comment ?? ""

            switch selectedItem.sugar {
            case SugarLevel.normal.rawValue:
                destinationVC.sugar = .normal
            case SugarLevel.seventy.rawValue:
                destinationVC.sugar = .seventy
            case SugarLevel.half.rawValue:
                destinationVC.sugar = .half
            case SugarLevel.thirty.rawValue:
                destinationVC.sugar = .thirty
            case SugarLevel.zero.rawValue:
                destinationVC.sugar = .zero
            default:
                destinationVC.sugar = .normal
            }
            
            switch selectedItem.ice {
            case IceLevel.full.rawValue:
                destinationVC.ice = .full
            case IceLevel.less.rawValue:
                destinationVC.ice = .less
            case IceLevel.no.rawValue:
                destinationVC.ice = .no
            case IceLevel.zero.rawValue:
                destinationVC.ice = .zero
            case IceLevel.hot.rawValue:
                destinationVC.ice = .hot
            default:
                destinationVC.ice = .full
            }

            switch selectedItem.size {
            case SizeLevel.big.rawValue:
                destinationVC.size = .big
            case SizeLevel.medium.rawValue:
                destinationVC.size = .medium
            default:
                destinationVC.size = .big
            }
            
            destinationVC.mixin = selectedItem.mixin == "" ? "" : "白玉珍珠"
    //        print("Order VC: \(selectedItem.mixin)")


        }
    
    
    
    
    
    
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

   
}

//以下為在 OrdersVC 中 extension 兩個 table delegate 的寫法
extension OrdersVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orders.count
    }
    // 在 table 內的 cell 中 以 OrderCell.switch 的串接之程式寫法
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderCell
        let order = orders[indexPath.row]
        
        cell.nameLabel.text = "姓名：\(order.name)"
        cell.itemLabel.text = "品項：\(order.item)"
        cell.sugarLabel.text = "甜度：\(order.sugar)"
        cell.iceLabel.text = "冰塊：\(order.ice)"
        cell.sizeLabel.text = "大小：\(order.size)"
        cell.mixinLabel.text = "加料：\(order.mixin ?? "")"
        cell.priceLabel.text = "\(order.price )元"
        cell.commentLabel.text = "備註：\(order.comment ?? "")"
        cell.picImageView.image = UIImage(named: "\(order.item)")
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let DBno = self.orders[indexPath.row].id
            SheetDBController.shared.deleteData(DBno: DBno)
            
            self.orders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            completion(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            // 以下程式會觸發 prepare func 其中 sender 就是 indexPath.row 的程式碼！這樣的寫法 好厲害！要謹記！
            self.performSegue(withIdentifier: "orderToFormVCSegue", sender: indexPath.row)
            
            completion(true)
        }
        
        editAction.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        
        var config = UISwipeActionsConfiguration()
        config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }

    
    
    
    
       
   }
   
   
   
   
   
   
   
   
   

