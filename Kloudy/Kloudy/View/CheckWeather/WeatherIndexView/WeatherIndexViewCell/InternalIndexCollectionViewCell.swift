//
//  InternalIndexCollectionViewCell.swift
//  Kloudy
//
//  Created by Byeon jinha on 2022/11/16.
//

import UIKit
import RxSwift

class InternalIndexCollectionViewCell: UICollectionViewCell {
    static let identifier = "InternalIndexCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func showToast(message : String, font: UIFont = UIFont.KFont.appleSDNeoBold20, cntCorrect: Int) {
        let toastLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/4, y: UIScreen.main.bounds.height - 170, width: 200, height: 40))
        print("난 showTaost 야")
        toastLabel.backgroundColor = UIColor.KColor.black
        toastLabel.textColor = UIColor.black
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        //            toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        self.addSubview(toastLabel)
        toastLabel.snp.makeConstraints{
//            $0.top.leading.equalToSuperview().offset(30)
//            $0.bottom.trailing.equalToSuperview().offset(100)
            $0.edges.equalToSuperview().offset(10)
            
        }
        
        UIView.animate(withDuration: 2.0, delay: 1.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
