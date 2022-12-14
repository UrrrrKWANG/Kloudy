//
//  IndexStepView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Lottie

class IndexStepView: UIView {
    
    let disposeBag = DisposeBag()
    var stepUIView = UIView()
    let stepValueLabel = UILabel()
    let stepValueBackgroundView = UIView()
    let stepExplainLabel = UILabel()
    let stepExplainBackgroundView = UIView()
    
    // 초기 저장 값
    let stepValue: BehaviorSubject<Int> = BehaviorSubject(value: 0)
    
    // presentButton / dismissButton 의 Tapped Event Subscribe
    let isPresentStepView = PublishSubject<Bool>()
    
    let imageString = PublishSubject<String>()
    let valueString = PublishSubject<Int>()
    let explainString = PublishSubject<String>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        isPresentStepView
            .subscribe(onNext: {
                if $0 {
                    self.layout()
                } else {
                    self.isViewDismiss()
                }
            })
            .disposed(by: disposeBag)
        
        imageString
            .subscribe(onNext: {
                self.changeStepImageView(name: $0)
            })
            .disposed(by: disposeBag)
        
        valueString
            .subscribe(onNext: {
                self.configureStepValueLabel(valueText: "지수 단계".localized + ": \($0)")
            })
            .disposed(by: disposeBag)
        
        explainString
            .subscribe(onNext: {
                self.configureStepExplainLabel(explainText: $0)
            })
            .disposed(by: disposeBag)
    }
    
    private func isViewDismiss() {
        self.subviews.forEach { $0.removeFromSuperview() }
        layoutIfNeeded()
    }
    
    private func layout() {
        [stepUIView, stepValueBackgroundView, stepExplainBackgroundView].forEach { self.addSubview($0) }
        
        stepUIView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7)
            $0.size.equalTo(242)
            $0.centerX.equalToSuperview()
        }
        
        stepValueBackgroundView.snp.makeConstraints {
            $0.top.equalTo(stepUIView.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview().inset(109)
            $0.height.equalTo(35)
        }
        
        stepExplainBackgroundView.snp.makeConstraints {
            $0.top.equalTo(stepValueBackgroundView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(68)
        }
        
        stepValueBackgroundView.addSubview(stepValueLabel)
        
        stepValueLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        stepExplainBackgroundView.addSubview(stepExplainLabel)
        
        stepExplainLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(50)
        }
    }
    
    private func attribute() {
        self.backgroundColor = UIColor.KColor.white
        configureStepImageView()
        configureStepValueBackgroundView()
        configureStepExplainBackgroundView()
    }
    
    private func configureStepImageView() {
        let stepLottieView = LottieAnimationView()
        stepLottieView.contentMode = .scaleAspectFit
        stepLottieView.play()
        stepLottieView.loopMode = .loop
        stepLottieView.backgroundBehavior = .pause
        stepUIView.addSubview(stepLottieView)
        stepLottieView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func changeStepImageView(name: String) {
        stepUIView.subviews.forEach { $0.removeFromSuperview() }
        stepUIView.layoutIfNeeded()

        let stepLottieView = LottieAnimationView(name: name)
        if stepLottieView.frame.width == 0 {
            let stepImageView = UIImageView()
            stepImageView.image = UIImage(named: name)
            stepImageView.contentMode = .scaleAspectFit
            stepUIView.addSubview(stepImageView)
            stepImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        } else {
            stepLottieView.contentMode = .scaleAspectFit
            stepLottieView.play()
            stepLottieView.loopMode = .loop
            stepLottieView.backgroundBehavior = .pause
            stepUIView.addSubview(stepLottieView)
            stepLottieView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    private func configureStepValueBackgroundView() {
        stepValueBackgroundView.backgroundColor = UIColor.KColor.indexYellow1
        stepValueBackgroundView.layer.cornerRadius = 8
    }
    
    private func configureStepValueLabel(valueText: String) {
        stepValueLabel.configureLabel(text: valueText, font: UIFont.KFont.appleSDNeoBold15, textColor: UIColor.KColor.indexYellow2)
        stepValueLabel.textAlignment = .center
        stepValueLabel.sizeToFit()
    }
    
    private func configureStepExplainBackgroundView() {
        stepExplainBackgroundView.backgroundColor = UIColor.KColor.gray05
        stepExplainBackgroundView.layer.cornerRadius = 8
    }
    
    private func configureStepExplainLabel(explainText: String) {
        stepExplainLabel.configureLabel(text: explainText, font: UIFont.KFont.appleSDNeoSemiBold15, textColor: UIColor.KColor.black)
        stepExplainLabel.setLineSpacing(spacing: 5)
        stepExplainLabel.numberOfLines = 2
        stepExplainLabel.textAlignment = .center
        stepExplainLabel.sizeToFit()
    }
}
