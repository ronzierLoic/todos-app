//
//  StorageManager.swift
//  todos-app
//
//  Created by lpiem on 21/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class DataModel {
    static var instance = DataModel()
    
    static var documentDirectory: URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)!
    static var dataFileUrl: URL = documentDirectory.appendingPathComponent("Checklist").appendingPathExtension("json")
    
    var lists: [CheckList] = []
    
    init() {
        NotificationCenter.default.addObserver( self,selector: #selector(self.saveCheckList), name: UIApplication.didEnterBackgroundNotification, object: nil)
        loadCheckListItems()
        print((FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)!)
        UserDefaults.standard.register(defaults: ["firstLaunch" : true])
        let firstLaunch = UserDefaults.standard.bool(forKey: "firstLaunch")
        print(firstLaunch)
        if(firstLaunch == true){
            self.handleFirstLaunch()
        }
    }
    
    @objc func saveCheckList() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(lists)
        try? data?.write(to: DataModel.dataFileUrl)
    }
    
    func loadCheckListItems() {
        if let data = try? Data(contentsOf: DataModel.dataFileUrl),
            let list = try? JSONDecoder().decode([CheckList].self, from: data) {
            self.lists = list
        }
    }
    
    func sortCheckLists() {
        lists.sort { $0.name.localizedCompare($1.name) == .orderedAscending }
    }
    
    func handleFirstLaunch() {
        lists.append(CheckList(name: "Edit your first item, Swipe me to delete"))
        UserDefaults.standard.set(false, forKey: "firstLaunch")
    }
}
