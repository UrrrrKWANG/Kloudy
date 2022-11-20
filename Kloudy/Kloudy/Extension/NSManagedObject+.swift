//
//  NSManagedObject+.swift
//  Kloudy
//
//  Created by Seulki Lee on 2022/11/20.
//

import Foundation
import CoreData

// https://github.com/PLREQ/PLREQ
extension NSManagedObject {
    func dataToString(forKey: String) -> String {
        return self.value(forKey: forKey) as? String ?? "정보를 불러올 수 없습니다."
    }
}
