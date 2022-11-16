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
    var stepImageView = UIView()
    let stepValueLabel = UILabel()
    let stepExplainLabel = UILabel()
    
    
    // 초기 저장 값
    let stepValue: BehaviorSubject<Int> = BehaviorSubject(value: 0)
    
    // presentButton / dismissButton 의 Tapped Event Subscribe
    let isPresentStepView = PublishSubject<Bool>()
    let imageString = PublishSubject<String>()
    let valueString = PublishSubject<Int>()
    
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
                self.stepValueLabel.text = "지수 단계: \($0)"
            })
            .disposed(by: disposeBag)
    }
    
    private func isViewDismiss() {
        self.subviews.forEach { $0.removeFromSuperview() }
        layoutIfNeeded()
    }
    
    private func layout() {
        [stepImageView, stepValueLabel, stepExplainLabel].forEach { self.addSubview($0) }
        
        stepImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7)
            $0.size.equalTo(242)
            $0.centerX.equalToSuperview()
        }
        
        stepValueLabel.snp.makeConstraints {
            $0.top.equalTo(stepImageView.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview().inset(109)
            $0.width.equalTo(100)
            $0.height.equalTo(35)
        }
        
        stepExplainLabel.snp.makeConstraints {
            $0.top.equalTo(stepValueLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(68)
        }
    }
    
    private func attribute() {
        self.backgroundColor = UIColor.KColor.white
        configureStepImageView()
        configureStepValueLabel()
        configureStepExplainLabel()
    }
    
    private func configureStepImageView() {
        let stepLottieView = LottieAnimationView(name: "rain_step4")
        stepLottieView.contentMode = .scaleAspectFit
        stepLottieView.play()
        stepLottieView.loopMode = .loop
        stepLottieView.backgroundBehavior = .pause
        stepImageView.addSubview(stepLottieView)
        stepLottieView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func changeStepImageView(name: String) {
        stepImageView.subviews.forEach { $0.removeFromSuperview() }
        stepImageView.layoutIfNeeded()

        let stepLottieView = LottieAnimationView(name: name)
        stepLottieView.contentMode = .scaleAspectFit
        stepLottieView.play()
        stepLottieView.loopMode = .loop
        stepLottieView.backgroundBehavior = .pause
        stepImageView.addSubview(stepLottieView)
        stepLottieView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureStepValueLabel() {
        stepValueLabel.text = "지수 단계: 4"
        stepValueLabel.font = UIFont.KFont.appleSDNeoBoldMini
        stepValueLabel.textColor = UIColor.init(red: 172/255, green: 124/255, blue: 0, alpha: 1.0)
        stepValueLabel.textAlignment = .center
        stepValueLabel.sizeToFit()
        stepValueLabel.backgroundColor = UIColor.init(red: 1, green: 249/255, blue: 219/255, alpha: 1)
        stepValueLabel.layer.cornerRadius = 8
    }
    
    private func configureStepExplainLabel() {
        stepExplainLabel.numberOfLines = 2
        stepExplainLabel.text = "우비를 뚫고 옷이 젖기도 하며 장화를 신어야 할 만큼 비가 옵니다."
        stepExplainLabel.font = UIFont.KFont.appleSDNeoSemiBoldMediumLarge
        stepExplainLabel.textColor = UIColor.KColor.black
        stepExplainLabel.textAlignment = .center
        stepExplainLabel.sizeToFit()
        stepExplainLabel.backgroundColor = UIColor.init(red: 247/255, green: 248/255, blue: 252/255, alpha: 1)
        stepExplainLabel.layer.cornerRadius = 8
    }
}
