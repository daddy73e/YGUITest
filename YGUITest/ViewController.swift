//
//  ViewController.swift
//  YGUITest
//
//  Created by Yeongeun Song on 2022/05/30.
//

import UIKit
import FlexLayout
import PinLayout
import Then

class ViewController: UIViewController {
    
    enum Section: CaseIterable {
        case main
    }
    
    var arr = ["Zedd", "Alan Walker", "David Guetta", "Avicii", "Marshmello", "Steve Aoki", "R3HAB", "Armin van Buuren", "Skrillex", "Illenium", "The Chainsmokers", "Don Diablo", "Afrojack", "Tiesto", "KSHMR", "DJ Snake", "Kygo", "Galantis", "Major Lazer", "Vicetone"
    ]
    
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: .init()).then {
        
        $0.isScrollEnabled = false
        $0.backgroundColor = .systemBackground
        $0.register(Test0Cell.self, forCellWithReuseIdentifier: "Test0Cell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = self.createLayout()
        self.view.addSubview(collectionView)
        self.setupDataSource()
        self.performQuery(with: nil)
    }
    
    func setupDataSource() {
        self.dataSource =
        UICollectionViewDiffableDataSource<Section, String>(collectionView: self.collectionView) { (collectionView, indexPath, dj) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Test0Cell", for: indexPath) as? Test0Cell else { preconditionFailure() }
            cell.configure(text: dj)
            return cell
        }
    }
    
    func performQuery(with filter: String?) {
        let filtered = self.arr.filter { $0.hasPrefix(filter ?? "") }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(filtered)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let contentSize = layoutEnvironment.container.effectiveContentSize
            let columns = contentSize.width > 800 ? 3 : 2
            let spacing = CGFloat(10)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(32))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            group.interItemSpacing = .fixed(spacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            return section
        }
        return layout
    }
}

extension ViewController {
    func layoutViews() {
        collectionView.pin.all(self.view.pin.safeArea)
    }
}



class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 재정의 오버라이드 메소드 임으로 리턴값으로 layout 속성값들을 받습니다.
        let attributes = super.layoutAttributesForElements(in: rect)
        
        // contentView의 left 여백
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0 // cell라인의 y값의 디폴트값
        attributes?.forEach { layoutAttribute in
            // cell일경우
            if layoutAttribute.representedElementCategory == .cell {
                // 한 cell의 y 값이 이전 cell들이 들어갔더 line의 y값보다 크다면
                // 디폴트값을 -1을 줬기 때문에 처음은 무조건 발동, x좌표 left에서 시작
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                // cell의 x좌표에 leftMargin값 적용해주고
                layoutAttribute.frame.origin.x = leftMargin
                // cell의 다음값만큼 cellWidth + minimumInteritemSpacing + 해줌
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                // cell의 위치값과 maxY변수값 중 최대값 넣어줌(라인 y축값 업데이트)
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
        }
        return attributes
    }
}
