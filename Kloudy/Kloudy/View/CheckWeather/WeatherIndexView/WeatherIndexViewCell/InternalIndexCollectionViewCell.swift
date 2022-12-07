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
    var borderWidth : CGFloat = 0 // Should be less or equal to the `radius` property
    var radius : CGFloat = 10
    var triangleHeight : CGFloat = 4
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func showToast(message: String, fontColor: UIColor, bgColor: UIColor) {
        let toastView = ToastView( viewColor: bgColor,
                                   tipStartX: message.count == 2 ? 21.5 : 52.5,
                                   tipWidth: 12.0,
                                   tipHeight: 8.0,
                                   fontColor: fontColor,
                                   text: message
        )
        self.addSubview(toastView)
        toastView.snp.makeConstraints{
            $0.top.equalTo(self.snp.bottom).offset(12)
            $0.trailing.equalToSuperview()
        }
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseOut, animations: {
            toastView.alpha = 0
        }, completion: {(isCompleted) in
            toastView.removeFromSuperview()
        })
    }
}

class ToastView: UIView {
    init(
        viewColor: UIColor,
        tipStartX: CGFloat,
        tipWidth: CGFloat,
        tipHeight: CGFloat,
        fontColor: UIColor,
        text: String
    ) {
        super.init(frame: .zero)
        self.backgroundColor = viewColor
        
        let path = CGMutablePath()
        let tipWidthCenter = tipWidth / 2.0
        let endXWidth = tipStartX + tipWidth
        
        path.move(to: CGPoint(x: tipStartX, y: 0))
        path.addLine(to: CGPoint(x: tipStartX + tipWidthCenter, y: -tipHeight))
        path.addLine(to: CGPoint(x: endXWidth, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = viewColor.cgColor
        
        self.layer.insertSublayer(shape, at: 0)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 6
        addLabel(fontColor: fontColor, text: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addLabel(fontColor: UIColor, text: String) {
        let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        toastLabel.font = UIFont.KFont.appleSDNeoMedium15
        toastLabel.textAlignment = .center;
        toastLabel.textColor = fontColor
        toastLabel.text = text
        toastLabel.layer.cornerRadius = 6;
        toastLabel.clipsToBounds = true
        
        self.addSubview(toastLabel)
        toastLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.left.right.equalToSuperview().inset(8)
        }
    }
}
