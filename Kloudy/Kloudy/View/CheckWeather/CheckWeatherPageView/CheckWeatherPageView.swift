//
//  CheckWeatherPageView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import SnapKit

class CheckWeatherPageView: UIView, UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout{
    var isViewBuild = true
    //TODO: 더미데이터, 아키텍쳐 확인 후 수정
    var locationTodayIndexArray: [[cellData]] = [
            [
                cellData(indexLevel: ["mask":4]),
                cellData(indexLevel: ["rain":4])
                ]
        ]
    lazy var viewBuildIndex = locationTodayIndexArray.count // 스크롤 뷰에서 그려질 때 반대로 그려져서, 예 : 더미데이터 7- > 6 -> 5 -> 4 -> 2 -> 3 개가 들어간 셀이 보여짐
    
    // 이미지 반환하는 메서드
    private func circleImage(imageName: String) -> UIImageView{
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: imageName)
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.frame = CGRect(x: 0, y: 0, width: 144, height: 144)
        return imageView
    }
    
    
    // 셀 개수 반환
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isViewBuild { // 처음 뷰를 빌드할 때
            viewBuildIndex -= 1
            return self.locationTodayIndexArray[viewBuildIndex].count
        } else { // 롱탭 제스쳐 이후
            return self.locationTodayIndexArray[self.pageSlider.currentPage].count
        }
    }
    
    // 셀 그리는 메서드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        if isViewBuild { // 처음 뷰를 빌드할 때
//            cell.addSubview(circleImage(imageName: self.locationTodayIndexArray[viewBuildIndex][indexPath[1]].indexLevel))
//        } else { // 롱탭 제스쳐 이후
//            if indexPath[1] < self.locationTodayIndexArray[        self.pageSlider.currentPage].count {
//                cell.addSubview(circleImage(imageName: self.locationTodayIndexArray[        self.pageSlider.currentPage][indexPath[1]].indexLevel))
//            }
//        }
        return cell
    }
    
    // 롱탭 제스쳐 이후 셀 사이즈 반환
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: 144 , height: 144)
    }
    
    
    // 순서가 바뀌면 Array 갱신
    // Re - order
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = self.locationTodayIndexArray[self.pageSlider.currentPage].remove(at: sourceIndexPath.row)
        self.locationTodayIndexArray[self.pageSlider.currentPage].insert(item, at: destinationIndexPath.row)
    }
    
    // colectionView 의 layout (여백 및 스크롤 방향 지정)
    private var layout : UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        return layout
    }
    
    //TODO: 페이지 개수 받아오는 부분 (임시)
    lazy var pageControlNum = locationTodayIndexArray.count
    
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
        scrollView.backgroundColor = UIColor.KColor.backgroundBlack
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var collectionView: UICollectionView?
    // 롱탭프레스제스쳐를 뷰마다 핸들링하기 위해 만든 collectionView Array
    private lazy var collectionViews = [collectionView]
    private var gestures = [UILongPressGestureRecognizer]()
    
    // 롱텝체스쳐 핸들링 메서드
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        isViewBuild = false // 뷰 빌드 이후임을 알려줌
        
        //지금 제스쳐가 해당 뷰에서 작동하는 지 확인
        guard let collectionView = collectionViews[self.pageSlider.currentPage+1] else {
            return
        }
        
        switch gesture.state {
        case .began:
            guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                return
            }
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
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
        //코어데이터에 있는 location을 차례대로 받아온다.
        //TODO: 페이지 별로 UIView를 올릴 부분
        for pageIndex in 0 ..< self.pageControlNum {
            let checkWeatherFrameView: UIView = UIView(frame: CGRect(x: CGFloat(pageIndex) * UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            self.scrollView.addSubview(checkWeatherFrameView)
            checkWeatherFrameView.backgroundColor = UIColor.KColor.clear
            
            let checkLocationWeatherView = CheckLocationWeatherView()
            checkWeatherFrameView.addSubview(checkLocationWeatherView)
            checkLocationWeatherView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.width.equalTo(UIScreen.main.bounds.width)
                $0.height.equalTo(181)
            }
            
//            let checkLocationWeatherView = CheckLocationWeatherView()
//            checkWeatherFrameView.addSubview(checkLocationWeatherView)
//            checkLocationWeatherView.snp.makeConstraints {
//                $0.height.equalTo(181)
//                $0.width.equalTo(UIScreen.main.bounds.width)
//                $0.top.equalToSuperview().offset(0)
//            }
            let checkWeatherCellLabelView = CheckWeatherCellLabelView()  //생활지수 라벨
            checkWeatherFrameView.addSubview(checkWeatherCellLabelView)
            checkWeatherCellLabelView.snp.makeConstraints{

                $0.width.equalTo(UIScreen.main.bounds.width)
                $0.height.equalTo(400)
                $0.top.equalTo(checkLocationWeatherView.snp.bottom).offset(25)
                $0.leading.trailing.equalToSuperview().inset(21) // label, button 패딩

//                $0.height.equalTo(UIScreen.main.bounds.height)
//                $0.width.equalTo(UIScreen.main.bounds.width)
//                $0.top.equalTo(checkLocationWeatherView.snp.bottom).offset(25)
//                $0.top.left.bottom.right.equalToSuperview().inset(UIScreen.main.bounds.width*0.05) // label, button 패딩

            }

            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            collectionView?.tintColor = .systemPink
            collectionView?.backgroundColor = UIColor.KColor.clear
            collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            collectionView?.delegate = self
            collectionView?.dataSource = self
            collectionViews.append(collectionView)

            checkWeatherCellLabelView.addSubview(collectionView!)
            collectionView!.snp.makeConstraints {
                $0.top.equalToSuperview().inset(30) // 나중에 checkWeatherCellLabelView안에 넣게 된다면 수정 할 것
                $0.leading.trailing.equalToSuperview()

//            checkWeatherFrameView.addSubview(collectionView!)
//            collectionView!.snp.makeConstraints {
//                $0.top.equalTo(checkWeatherCellLabelView.snp.bottom).offset(30)
//
//                $0.width.equalTo(UIScreen.main.bounds.width)
//                $0.height.equalTo(UIScreen.main.bounds.height)
            }
            
            let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_ :)))
            gestures.append(gesture)
            collectionViews[collectionViews.count-1]?.addGestureRecognizer(gesture)
        }
    }
}

// 현재 페이지 index 받아올 extension
extension CheckWeatherPageView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let nextPage = Int(targetContentOffset.pointee.x / self.frame.width)
        self.pageSlider.currentPage = nextPage
    }
}

//TODO: 데이터 받아올 임시 struct
struct cellData : Equatable {
    var indexLevel: [ String : Int ]
    
}
