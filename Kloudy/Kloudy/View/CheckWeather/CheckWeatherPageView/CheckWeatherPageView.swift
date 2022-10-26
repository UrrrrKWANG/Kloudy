//
//  CheckWeatherPageView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import SnapKit

class CheckWeatherPageView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var layout : UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return layout
    }
    

    //TODO: 페이지 개수 받아오는 부분 (임시)
    let pageControlNum = 1
    
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
        scrollView.isPagingEnabled = true // 페이지가 구역에 맞게 넘어가게 만들어줌
        scrollView.delegate = self // scrollView의 델리게이트, 하단 extention에 따로 만듬
        scrollView.contentSize = CGSize(width: CGFloat(pageControlNum) * UIScreen.main.bounds.width, height: UIScreen.main.bounds.height) // 컨텐츠사이즈
        scrollView.backgroundColor = .black
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
        for pageIndex in 0 ..< self.pageControlNum {
            let checkWeatherFrameView: UIView = UIView(frame: CGRect(x: CGFloat(pageIndex) * UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            self.scrollView.addSubview(checkWeatherFrameView)
            checkWeatherFrameView.backgroundColor = .orange
            
            let checkWeatherCellLabelView = CheckWeatherCellLabelView()  //생활지수 라벨
            checkWeatherFrameView.addSubview(checkWeatherCellLabelView)
            checkWeatherCellLabelView.snp.makeConstraints{
                $0.height.equalTo(UIScreen.main.bounds.height)
                $0.width.equalTo(UIScreen.main.bounds.width)
                $0.top.left.bottom.right.equalToSuperview().inset(UIScreen.main.bounds.width*0.05) // label, button 패딩
            }
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            collectionView.tintColor = .systemPink
            collectionView.backgroundColor = .clear
            
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            collectionView.delegate = self
            collectionView.dataSource = self
            
            checkWeatherFrameView.addSubview(collectionView)
      
            
        }
    }
    private func circleImage(imageName: String) -> UIImageView{
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: imageName)
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.frame = CGRect(x: 0, y: 0, width: 144, height: 144)
        return imageView
    }
    
    
    var todayIndexArray: [cellData] = [
        cellData(indexName: "01.circle"),
        cellData(indexName: "02.circle"),
        cellData(indexName: "03.circle"),
        cellData(indexName: "04.circle"),
        cellData(indexName: "05.circle"),
        cellData(indexName: "06.circle"),
        cellData(indexName: "07.circle")
    ]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayIndexArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.addSubview(circleImage(imageName: todayIndexArray[indexPath[1]].indexName))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: 144 , height: 144)
    }
    // Re - order
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = todayIndexArray.remove(at: sourceIndexPath.row)
        todayIndexArray.insert(item, at: destinationIndexPath.row)
    }
}


extension CheckWeatherPageView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let nextPage = Int(targetContentOffset.pointee.x / self.frame.width)
        //        print(nextPage) // 다음페이지 인덱스를 계산해 놓은 변수 입니다. :)
        self.pageSlider.currentPage = nextPage
    }
}


struct cellData : Equatable {
    var indexName: String
}



