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
        self.layer.applySketchShadow(color: UIColor.KColor.primaryBlue01, alpha: 0.15, x: 0, y: 0, blur: 10, spread: 0)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var isSelected: Bool{
          didSet {
              self.backgroundColor = isSelected ? .white : .clear
              }
      }
}
