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
    
    let collectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
}

extension ViewController {
    func layoutViews() {
        collectionView.pin.all(self.view.pin.safeArea)
    }
}

