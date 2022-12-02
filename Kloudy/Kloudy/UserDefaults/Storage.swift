//
//  Storage.swift
//  Kloudy
//
//  Created by 이영준 on 2022/12/02.
//

import Foundation

public class Storage {
    class func isFirst() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "isFirst") == nil {
            defaults.set("No", forKey: "isFirst")
            return true
        } else {
            return false
        }
    }
}
