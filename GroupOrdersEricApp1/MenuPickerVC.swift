//
//  MenuPickerVC.swift
//  GroupOrdersEricApp1
//
//  Created by user on 2020/8/27.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
// 運用 PickerView 的元件作為 飲料選單 的 VC(View Controller)
class MenuPickerVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    // items 就是陣列 [Item]的內部資料
    var items = [Item]()
    
    
    @IBOutlet weak var menuPickerOutlet: UIPickerView!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    
    // 按下 Ｘ button 時 執行的程式 利用 performSegue 的 ID 回到 FormVC 中
    @IBAction func returnButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToFormVC", sender: nil)
    }
    
    
    // 當按下 submit Button 時 執行 unwindToFormVC 的 Segue 同時觸發 prepare func 的 sender submitButton 程式
    @IBAction func submitButtonPressed(_ sender: Any) {
     
        performSegue(withIdentifier: "unwindToFormVC", sender: "submitButton")
        
    }
    
    
    // 當 Segue 觸發 prepare func 時，執行以下程式
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 抓取 menuPicker 第一筆 row = 0 的資料。就是 drink
        let selectedDrink = menuPickerOutlet.selectedRow(inComponent: 0)
        
        // 抓取 menuPicker 第二筆 row = 1 的資料。就是 size
        let selectedSize = menuPickerOutlet.selectedRow(inComponent: 1)
        
        //以下就是 sender = submitButton 程式碼執行
        if sender != nil {

            let destinationVC = segue.destination as! FormVC
            destinationVC.selectedDrink = selectedDrink
            destinationVC.selectedSize = selectedSize
            
            destinationVC.sizeSegOutlet.isEnabled = items[selectedDrink].option.count == 2 ? true : false
            
            destinationVC.updateFormOutlet()
            destinationVC.updateFormPrice()
            
        }
        
    }
    
 
    // 以下為 遵從 UIPickerViewDelegate,UIPickerViewDataSource 所寫的 pickerView 中 2 個 Component func 一個是 drink 一個是 size
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
        }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return items.count
        }else {
            let row = menuPickerOutlet.selectedRow(inComponent: 0)
            if row == -1 {
                return items[0].option.count
            }
            else{
                return items[row].option.count
            }
        }
        
    }
   // 在 pickerView 中可以有很多 component 其對應的程式碼如下設計
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            
    //        print(row)
            let component0Row = pickerView.selectedRow(inComponent: 0)
            
            if component == 0 {
                let title = items[row].drink
    //            print(title)
                return title
            } else { // 以下抓取 陣列資料 items 的寫法 謹記 ！
                let size = items[component0Row].option[row].size
    //            print("drink: \(items[component0Row].drink), item option: \( items[component0Row].option[row]), size: \(items[component0Row].option[row].size)")
                return size
            }
        }
        
        
        // 以下這個 func 的寫法。 謹記 ！
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if component == 0 {
                pickerView.reloadComponent(1)
            }
            
    }

    
    
    
    
    
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButtonOutlet.layer.cornerRadius = submitButtonOutlet.frame.height / 4
        
        
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

}
