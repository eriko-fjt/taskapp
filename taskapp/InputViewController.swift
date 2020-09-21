//
//  InputViewController.swift
//  taskapp
//
//  Created by 藤田恵梨子 on 2020/07/13.
//  Copyright © 2020 eriko.fujita. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications  // 7.3で追加

class InputViewController: UIViewController {
    
    
    
    @IBOutlet weak var titleTextField: UITextField!
    
    
    @IBOutlet weak var contentsTextView: UITextView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    
    
    
    // 6.10で追記  インスタンスを生成している
    let realm = try! Realm()
    
    // 6.8で追記。モデル
    var task: Task!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 6.10で追記
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        //それぞれの欄に、DBの値を代入
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        
        // 課題　カテゴリ
        categoryTextField.text = task.category
    
    }
    
    
    
    // 画面遷移時に、画面が消える際呼ばれる
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.task.category = self.categoryTextField.text  // 課題　Taskのカテゴリカラムに、欄に記入されたカテゴリを代入
            self.realm.add(self.task, update: .modified)
        }
        
        setNotification(task: task) // 7.3で追加
        
        super.viewWillDisappear(animated)
    }
    
    // タスクのローカル通知を登録する  7.3で追記
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        
        // タイトルと内容を設定（中身がない場合メッセージなしで音だけの通知になるので「XXなし」を表示する）
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        
        if task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        
        content.sound = UNNotificationSound.default
        
        // ローカル通知が発動するtrigger(日付マッチ）を作成　　　! (7.3で追加）
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)
        
        // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録OK") // errorがnilならローカル通知の登録に成功したと表示する。　errorがあればerrorを表示
        }
        
        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/-----------")
                print(request)
                print("-----------/")
            }
        }
        
    }
    
    
    @objc func dismissKeyboard() {
        // キーボードを閉じる
        view.endEditing(true)
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
