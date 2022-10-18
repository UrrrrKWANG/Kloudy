//
//  CheckWeatherPageView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit

class CheckWeatherPageView: UIView{
//TODO: 페이지 개수 받아오는 부분 (임시)
    let pageControlNum = 4
    
    private lazy var pageSlider: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pageControlNum // 페이지 개수
        pageControl.hidesForSinglePage = true // 페이지가 하나일 때는 숨어요 :)
//TODO: extension 색상 추가시 인디케이터 변경 (임시)
        pageControl.currentPageIndicatorTintColor = .green // 현재 인디케이터 색상 (임시)
//        pageControl.pageIndicatorTintColor = .systemGray3 // 인디케이터 색상
        return pageControl
    }()
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.frame)
        scrollView.showsHorizontalScrollIndicator = false // 가로스크롤인디케이터 숨김
        scrollView.showsVerticalScrollIndicator = false // 세로스크롤인디케이터 숨김
//TODO: 스크롤뷰 잘들어 오는지 확인하려고 배경색 임시로 넣어놨어요.
        scrollView.backgroundColor = .lightGray
        scrollView.isPagingEnabled = true // 페이지가 구역에 맞게 넘어가게 만들어줌
        scrollView.delegate = self // scrollView의 델리게이트, 하단 extention에 따로 만듬
        scrollView.contentSize = CGSize(width: CGFloat(pageControlNum) * UIScreen.main.bounds.width, height: UIScreen.main.bounds.height) // 컨텐츠사이즈
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {  //레이아웃 서브뷰 공부 더하기
        self.addSubview(pageSlider)
        self.addSubview(scrollView)
        self.pageSlider.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(UIScreen.main.bounds.height)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(390)
        }
        self.scrollView.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(UIScreen.main.bounds.height - 133)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(83)
        }
        
//TODO: 페이지 별로 UIView를 올릴 부분
//        for pageIndex in 0 ..< self.pageControlNum {
//        }
    }
}
extension CheckWeatherPageView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let nextPage = Int(targetContentOffset.pointee.x / self.frame.width)
//        print(nextPage) // 다음페이지 인덱스를 계산해 놓은 변수 입니다. :)
        self.pageSlider.currentPage = nextPage
    }
}
