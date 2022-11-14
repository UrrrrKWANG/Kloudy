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
    var stepLottieView = LottieAnimationView()
    let stepValueLabel = UILabel()
    let stepExplainLabel = UILabel()
    
    // 초기 저장 값
    let stepValue: BehaviorSubject<Int> = BehaviorSubject(value: 0)
    
    // Tap 했을 시 변경되는 지수 단계 값
    //
    
    let presentButtonTapped: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        presentButtonTapped
            .subscribe(onNext: {
                if $0 {
                    self.layout()
                } else {
                    print("👍")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func isPresentButtonTapped() {
        
    }
    
    private func layout() {
        [stepLottieView, stepValueLabel, stepExplainLabel].forEach { self.addSubview($0) }
        
        stepLottieView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7)
            $0.size.equalTo(242)
            $0.centerX.equalToSuperview()
        }
        
        stepValueLabel.snp.makeConstraints {
            $0.top.equalTo(stepLottieView.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview().inset(125)
            $0.width.equalTo(100)
            $0.height.equalTo(35)
        }
        
        stepExplainLabel.snp.makeConstraints {
            $0.top.equalTo(stepValueLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
    }
    
    private func attribute() {
        self.backgroundColor = UIColor.KColor.white
        configureStepLottieView()
        configureStepValueLabel()
        configureStepExplainLabel()
    }
    
    private func configureStepLottieView() {
        stepLottieView.backgroundColor = .green
        stepLottieView = LottieAnimationView(name: "rain_step4")
        stepLottieView.contentMode = .scaleAspectFit
        stepLottieView.play()
        stepLottieView.loopMode = .loop
        stepLottieView.backgroundBehavior = .pauseAndRestore
    }
    
    private func configureStepValueLabel() {
        stepValueLabel.text = "지수 단계: 4"
        stepValueLabel.font = UIFont.KFont.appleSDNeoBoldMini
        stepValueLabel.textColor = UIColor.init(red: 172/255, green: 124/255, blue: 0, alpha: 1.0)
        stepValueLabel.textAlignment = .center
        stepValueLabel.sizeToFit()
    }
    
    private func configureStepExplainLabel() {
        stepExplainLabel.numberOfLines = 2
        stepExplainLabel.text = "우비를 뚫고 옷이 젖기도 하며 장화를 신어야 할 만큼 비가 옵니다."
        stepExplainLabel.font = UIFont.KFont.appleSDNeoSemiBoldMediumLarge
        stepExplainLabel.textColor = UIColor.KColor.black
        stepExplainLabel.textAlignment = .center
        stepExplainLabel.sizeToFit()
    }
}
