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
        // ????????? ??????????????? ????????? ????????? ??????????????? layout ??????????????? ????????????.
        let attributes = super.layoutAttributesForElements(in: rect)
        
        // contentView??? left ??????
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0 // cell????????? y?????? ????????????
        attributes?.forEach { layoutAttribute in
            // cell?????????
            if layoutAttribute.representedElementCategory == .cell {
                // ??? cell??? y ?????? ?????? cell?????? ???????????? line??? y????????? ?????????
                // ??????????????? -1??? ?????? ????????? ????????? ????????? ??????, x?????? left?????? ??????
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                // cell??? x????????? leftMargin??? ???????????????
                layoutAttribute.frame.origin.x = leftMargin
                // cell??? ??????????????? cellWidth + minimumInteritemSpacing + ??????
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                // cell??? ???????????? maxY????????? ??? ????????? ?????????(?????? y?????? ????????????)
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
        }
        return attributes
    }
}
