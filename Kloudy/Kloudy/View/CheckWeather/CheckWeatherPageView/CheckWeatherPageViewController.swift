import UIKit
import SnapKit
class CheckWeatherViewController: UICollectionView {
    private lazy var todayIndex: UILabel = {
           let label = UILabel()
           label.textColor = UIColor.KColor.gray04
           label.text = "오늘의 생활 지수"
           label.font = UIFont.KFont.appleSDNeoSemiBoldSmall
           return label
       }()
    var todayIndexArray: [cellData] = [
        cellData(indexName: "01.circle"),
        cellData(indexName: "02.circle"),
        cellData(indexName: "03.circle"),
        cellData(indexName: "04.circle"),
        cellData(indexName: "05.circle"),
        cellData(indexName: "06.circle"),
        cellData(indexName: "07.circle")
    ]
    override func layoutSubviews() {
        addSubview(todayIndex)
        self.todayIndex.snp.makeConstraints{
            $0.width.equalTo(100)
            $0.height.equalTo(14)
            $0.leading.centerY.equalToSuperview()
        }
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.delegate = self
        self.dataSource = self
    }
}


extension CheckWeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.todayIndexArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.addSubview(circleImage(imageName: self.todayIndexArray[indexPath[1]].indexName))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: 144 , height: 144)
    }
    
    // Re - order
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = self.todayIndexArray.remove(at: sourceIndexPath.row)
        self.todayIndexArray.insert(item, at: destinationIndexPath.row)
    }

    // 셀이 선택되었을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let imageInfo = self.todayIndexArray[indexPath.item]
        
        print(imageInfo.indexName)
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
