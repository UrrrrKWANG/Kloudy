//
//  String+.swift
//  Kloudy
//
//  Created by Seulki Lee on 2022/11/22.
//

import Foundation

extension String {
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }
}
