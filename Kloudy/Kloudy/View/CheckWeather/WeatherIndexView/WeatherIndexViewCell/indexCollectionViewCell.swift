//
//  indexCollectionViewCell.swift
//  Kloudy
//
//  Created by Byeon jinha on 2022/11/22.
//

import UIKit

class indexCollectionViewCell: UICollectionViewCell {
    static let identifier = "indexCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 21
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var isSelected: Bool{
          didSet {
                  if isSelected {
                      self.backgroundColor = .white
                  } else {
                      self.backgroundColor = .clear
                  }
              }
      }
}
