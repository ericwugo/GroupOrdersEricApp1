//
//  FormVC.swift
//  GroupOrdersEricApp1
//
//  Created by user on 2020/8/26.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class FormVC: UIViewController {
    // 預設 isNewOrder 是 true 值
    var isNewOrder = true
        
        // For API data transfer
    // newOrder 是 struct Order 的型別之定義
        var newOrder = Order()
    
    //    var id = ""
        var item = ""
        var name = ""
        var sugar: SugarLevel = .normal
        var ice: IceLevel = .full
        var size: SizeLevel = .big
        var price = ""
        var comment = ""
        var mixin = ""
        // 飲料菜單 是來自 陣列資料 [Item] 的程式
        // Menu Data
        var items = [Item]()
        var selectedDrink = 0
        var selectedSize = 0
 // 以下為各種 @IBOutlet 連結設定
    @IBOutlet weak var nameTextFieldOutlet: UITextField!
    @IBOutlet weak var itemTextFieldOutlet: UITextField!
    @IBOutlet weak var sugarSegOutlet: UISegmentedControl!
    @IBOutlet weak var hotSwitchOutlet: UISwitch!
    @IBOutlet weak var iceSegOutlet: UISegmentedControl!
    @IBOutlet weak var sizeSegOutlet: UISegmentedControl!
    @IBOutlet weak var priceTextFieldOutlet: UITextField!
    @IBOutlet weak var commentTextFieldOutlet: UITextField!
    
    @IBOutlet weak var addWBubbleButtonOutlet: UIButton!
    @IBOutlet weak var menuButtonOutlet: UIButton!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    
    
    // 以下配合 在 main.storyboard 中 設定 sugar segment 的 5 種 sugar case 的資料與程式碼的對應
    @IBAction func sugarSegAction(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            sugar = .normal
        case 1:
            sugar = .seventy
        case 2:
            sugar = .half
        case 3:
            sugar = .thirty
        case 4:
            sugar = .zero
        default:
            sugar = .normal
        }
        
        
    }
    
    // 以下當點選 熱飲時 會把 選擇冰塊 種類給 block 起來
    @IBAction func hotDrinkSwitch(_ sender: UISwitch) {
        if sender.isOn {
            iceSegOutlet.isEnabled = false
            ice = .hot
        } else {
            iceSegOutlet.isEnabled = true
        }
        
    }
    
    // 以下配合 在 main.storyboard 中 設定 ice segment 的 4 種 ice case 的資料與程式碼的對應
    @IBAction func iceSegAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            ice = .full
        case 1:
            ice = .less
        case 2:
            ice = .no
        case 3:
            ice = .zero
        default:
            ice = .full
        }
        
    }
    // 以下配合 在 main.storyboard 中 設定 size segment 的 2 種 size case 的資料與程式碼的對應
    @IBAction func sizeSegAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            size = .big
        case 1:
            size = .medium
        default:
            size = .big
        }
        
    }
    
    //當點選 “白玉珍珠” 時 執行的程式，除了讓外觀變化外 並同步更新 updateFormPrice 的 func
    @IBAction func addWBubbleSelected(_ sender: Any) {
        
       addWBubbleButtonOutlet.isSelected = !addWBubbleButtonOutlet.isSelected
        
        if addWBubbleButtonOutlet.isSelected {
            addWBubbleButtonOutlet.layer.borderWidth = 3
            addWBubbleButtonOutlet.layer.borderColor = UIColor(red: 0.73, green: 0.60, blue: 0.41, alpha: 1.00).cgColor
            addWBubbleButtonOutlet.setTitleColor( #colorLiteral(red: 0.7294117647, green: 0.6039215686, blue: 0.4078431373, alpha: 1) , for: .selected)
        } else {
            addWBubbleButtonOutlet.layer.borderWidth = 0
        }
        
        mixin = addWBubbleButtonOutlet.isSelected ? "白玉珍珠" : ""
        if itemTextFieldOutlet.text == "" {
            priceTextFieldOutlet.text = ""
        } else {
            updateFormPrice()
        }
       
        
    }
    
    // 當 menu Button 點選後 執行 "formToPickerSegue" 的 Modally Segue 同時觸發 prepare func 的 menu 程式
    // 這樣的寫法與應用  在不同畫面間資料的傳遞 非常有用
    @IBAction func menuButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "formToPickerSegue", sender: "menu")
       
        
    }
    
    // 當 orderList Button 點選後 執行 "formToPickerSegue" 的 show Segue 同時觸發 prepare func 的 list 程式
    @IBAction func orderListButtonPresed(_ sender: UIButton) {
        
       performSegue(withIdentifier: "formToOrdersVCSegue", sender: "list")
        
        
    }
    
    // 當 submitButton 被點選時的程式判斷 如果 姓名 與 飲料沒被點選時 不允許資料送出
    @IBAction func submitButtonPressed(_ sender: UIButton) {
       
        
        if nameTextFieldOutlet.text?.isEmpty == false, itemTextFieldOutlet.text?.isEmpty == false {
            // 當資料輸入無誤時，則執行  "formToOrderVCSegue" 的。Segue 並啟動 prepare 的 submitNewOrder func 的程式碼
                if isNewOrder {
                    performSegue(withIdentifier: "formToOrdersVCSegue", sender: "submitNewOrder")
        //            print(sender.tag)
                    print("submit button pressed: \(isNewOrder)")
                } else {  // 如果不是 NewOrder 則執行 "unwindToOrderVC" 的 Segue 並觸發啟動 prepare 的"editOrder" func程式碼
                    performSegue(withIdentifier: "unwindToOrderVC", sender: "editOrder")
                    print("submit button pressed: \(isNewOrder)")
                }
                
            } else { // 以下的程式碼均是 必填欄位 "name" 與 "item" 的程式判斷
                if nameTextFieldOutlet.text?.isEmpty == true {
                    nameTextFieldOutlet.layer.borderWidth = 1
                    nameTextFieldOutlet.layer.borderColor = UIColor.systemPink.cgColor
                } else {
                    nameTextFieldOutlet.layer.borderColor = UIColor.clear.cgColor
                }
                
                if itemTextFieldOutlet.text?.isEmpty == true {
                    itemTextFieldOutlet.layer.borderWidth = 1
                    itemTextFieldOutlet.layer.borderColor = UIColor.systemPink.cgColor
                } else {
                    itemTextFieldOutlet.layer.borderColor = UIColor.clear.cgColor
                }
                
            }
        
        
        
        
    }
    
    
     // Deal with mixins and update price UI display
    // 以下是 價錢更新的 程式碼判斷 ，其中 mixinPrice 就是 "白玉珍珠" 被點選時 要加 10 元的程式碼
        func updateFormPrice() {
            let mixinPrice = mixin == "" ? 0 : 10 // 這樣的價錢判斷寫法 很高端啊 ！一行程式就搞定！
    //        print("mixin price : \(mixinPrice)")
            
            if isNewOrder { // 如果是 newOrder 的 item 價錢判斷
                price = String( items[selectedDrink].option[selectedSize].price)
                
            }
            // 以下為總價更新的價錢判斷
            let totalPrice = Int(price)! + mixinPrice
            priceTextFieldOutlet.text = String(totalPrice)
        
        }
    
    
    // 以下為 更新表單資料的程式設定
    func updateFormOutlet() {
        
        if  isNewOrder {
            itemTextFieldOutlet.text = items[selectedDrink].drink
            size = items[selectedDrink].option[selectedSize].size == "L" ? SizeLevel.big : SizeLevel.medium // 這樣"是否"判斷的程式法 很高端
        } else {
            itemTextFieldOutlet.text = item
            
        }

        switch size {
        case .big:
            sizeSegOutlet.selectedSegmentIndex = 0
        case .medium:
            sizeSegOutlet.selectedSegmentIndex = 1
        
        }
    }
    
    
    
    
    // 這是 unwind Segue 的寫法 ：當畫面來回切換時 在來源畫面要先設定此程式碼 並在 storyboard 拉取設定！切記這樣的程式碼設計上的運用！
    @IBAction func unwindToFormVC(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuButtonOutlet.layer.cornerRadius = menuButtonOutlet.frame.height / 4
        addWBubbleButtonOutlet.layer.cornerRadius = addWBubbleButtonOutlet.frame.height / 4
        submitButtonOutlet.layer.cornerRadius = submitButtonOutlet.frame.height / 4
// 在起始畫面時，首先就是要取得 getMenuData 的資料 (在 MenuDB.swift 中定義)
        MenuDBController.shared.getMenuData { (items) in
            self.items = items!
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // 以下為送出訂單 submitNeworder 的 func 程式碼
    func submitNewOrder() {
        // need to revise. replace the outlet parts
        newOrder.name = nameTextFieldOutlet.text ?? ""
        newOrder.item = itemTextFieldOutlet.text ?? ""
        newOrder.sugar = sugar.rawValue
        newOrder.size = size.rawValue
        newOrder.price = priceTextFieldOutlet.text ?? ""
        newOrder.ice = ice.rawValue
        newOrder.mixin = mixin
        
        if commentTextFieldOutlet.text != "" {
            newOrder.comment = commentTextFieldOutlet.text
        }

    }
    
    
    
    
    
    
    // 以下為執行 所有 Segue 時 觸發 prepare func 對應不同 sender 名稱的程式語法, 非常重要！！！
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
        let sender = sender as! String
        //以下為 prepare sender = menu 的程式碼 目的VC 轉型到 MenuPickerVC ！好厲害的寫法！
        if sender == "menu" {
            let destinationVC = segue.destination as! MenuPickerVC
            
            MenuDBController.shared.getMenuData { (items) in
                destinationVC.items = items!
            }

        }else
        
        {
                    
                    let destinationVC = segue.destination as! OrdersVC
            //        print(sender.tag)
            // 以下為 prepare sender = submitNewOrder 的程式碼！好厲害的寫法！
                    if sender == "submitNewOrder" {
                    
                        submitNewOrder()
                        SheetDBController.shared.postData(newOrder: newOrder) {
                            print("post data") // 這樣的 print 寫法應用於 程式除錯時的判斷 ！！！
                            
                            SheetDBController.shared.getData { (orders) in
                                destinationVC.orders = orders!
        //                        let totalCup = orders?.count
        //                        destinationVC.totalCupLabelOutlet.text = String(totalCup ?? 0)
                                DispatchQueue.main.async {
                                    destinationVC.tableView.reloadData()
                                    destinationVC.updateTotalOrderInfo()
        //                            print("get data")
                                }
                                        
                            }
                        }
                    // 以下為 prepare sender = editOrder 的程式碼！好厲害的寫法！
                    } else if sender == "editOrder" {
                        submitNewOrder()
                        SheetDBController.shared.putData(updatedOrder: newOrder, DBID: newOrder.id) {
                            
                            SheetDBController.shared.getData { (orders) in
                                destinationVC.orders = orders!
                                       
                                DispatchQueue.main.async { //放入背景程式中執行！Cool !!!
                                    destinationVC.tableView.reloadData()
        //                            print("get data")
                                    destinationVC.updateTotalOrderInfo()
                                }
                                        
                            }
                        }
                        
                    } else {
                        
                        SheetDBController.shared.getData { (orders) in
                            destinationVC.orders = orders!
                            
                            DispatchQueue.main.async {
                                destinationVC.tableView.reloadData()
        //                        print("get data")
                                destinationVC.updateTotalOrderInfo()
                            }
                                        
                        }
                    }
                    
                }
        
    
    }
    
   
    //以下 override func 是應用於 editOrder 時 將欄位資料帶出來的程式 ！這樣的應用 要謹記於心啊！！！
    override func viewWillAppear(_ animated: Bool) {

        nameTextFieldOutlet.text = name
        itemTextFieldOutlet.text = item
        priceTextFieldOutlet.text = mixin == "" ? price : String( Int(price)! + 10 )
        commentTextFieldOutlet.text = comment
        addWBubbleButtonOutlet.isSelected = mixin == "" ? false : true
        switch sugar {
        case .normal:
            sugarSegOutlet.selectedSegmentIndex = 0
        case .seventy:
            sugarSegOutlet.selectedSegmentIndex = 1
        case .half:
            sugarSegOutlet.selectedSegmentIndex = 2
        case .thirty:
            sugarSegOutlet.selectedSegmentIndex = 3
        case .zero:
            sugarSegOutlet.selectedSegmentIndex = 4
        }
        
        
        switch ice {
        case .full:
            iceSegOutlet.selectedSegmentIndex = 0
            hotSwitchOutlet.isOn = false
        case .less:
            hotSwitchOutlet.isOn = false
            iceSegOutlet.selectedSegmentIndex = 1
        case .no:
            hotSwitchOutlet.isOn = false
            iceSegOutlet.selectedSegmentIndex = 2
        case .zero:
            hotSwitchOutlet.isOn = false
            iceSegOutlet.selectedSegmentIndex = 3
        case .hot:
            hotSwitchOutlet.isOn = true
            iceSegOutlet.isEnabled = false
        }

        switch size {
        case .big:
            sizeSegOutlet.selectedSegmentIndex = 0
        case .medium:
            sizeSegOutlet.selectedSegmentIndex = 1
            
        }


        
    }
    
    
    
    
    
    
    
    
}
