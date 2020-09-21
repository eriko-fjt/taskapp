//
//  Task.swift
//  taskapp
//
//  Created by 藤田恵梨子 on 2020/07/14.
//  Copyright © 2020 eriko.fujita. All rights reserved.
//

import RealmSwift

class Task: Object {
    
    // 管理用ID プライマリーキー
    @objc dynamic var id = 0
    
    // 課題用, カテゴリ
    @objc dynamic var category: String! = ""
    
    // タイトル
    @objc dynamic var title = ""
    
    // 内容
    @objc dynamic var contents = ""
    
    // 日時
    @objc dynamic var date = Date()
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}
