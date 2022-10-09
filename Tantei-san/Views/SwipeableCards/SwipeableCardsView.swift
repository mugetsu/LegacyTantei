//
//  SwipeableCardsView.swift
//  Tantei-san
//
//  Created by Randell on 9/10/22.
//

import Foundation
import UIKit
import SnapKit

final class SwipeableCardsView: UIView {
    private let flowLayout = UICollectionViewFlowLayout()
    private let reuseIdentifier = "swipeableCardCell"
    public var dataSource: SwipeableCardsViewDataSource!
    public var delegate: SwipeableCardsViewDelegate?
    private var collectionView: UICollectionView!
    private var indexOfCellBeforeDragging = 0
    private var viewsCount: Int {
        return dataSource.swipeableCardsNumberOfItems(self)
    }
    private var cardSize: CGSize {
        get { return flowLayout.itemSize }
        set { flowLayout.itemSize = newValue }
    }
    var cardWidthFactor: CGFloat = 0.8
    var cardSpacing: CGFloat {
        get { return flowLayout.minimumLineSpacing }
        set { flowLayout.minimumLineSpacing = newValue }
    }
    var insets: UIEdgeInsets {
        get { return flowLayout.sectionInset }
        set { flowLayout.sectionInset = newValue }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLayout()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setCardSize()
    }
    
    func reloadData() {
        setCardSize()
        collectionView.reloadData()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = getIndexOfMajorCell()
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        let cellIndexOffset = velocity.x == 0 ? 0 : (velocity.x > 0 ? 1: -1)
        let indexOfDestinationCell = max(0, min(viewsCount - 1, indexOfCellBeforeDragging + cellIndexOffset))
        let indexPath = IndexPath(row: indexOfDestinationCell, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private func getIndexOfMajorCell() -> Int {
        let itemWidth = flowLayout.itemSize.width
        let proportionalOffset = flowLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let safeIndex = max(0, min(numberOfItems - 1, index))
        return safeIndex
    }
}

// MARK: UI Setup
private extension SwipeableCardsView {
    func configureLayout() {
        flowLayout.scrollDirection = .horizontal

        collectionView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SwipeableCardCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(snp.top)
            $0.bottom.equalTo(snp.bottom)
            $0.left.equalTo(snp.left)
            $0.right.equalTo(snp.right)
        }
    }
    
    func setCardSize() {
        let singleCardWidth = bounds.width - insets.left - insets.right
        let multiCardsWidth = bounds.width * cardWidthFactor
        let cardWidth = viewsCount > 1 ? multiCardsWidth : singleCardWidth
        let cardHeght = collectionView.bounds.height - insets.top - insets.bottom
        cardSize = CGSize(width: cardWidth, height: cardHeght)
    }
}

// MARK: UICollectionViewDelegate & UICollectionViewDataSource
extension SwipeableCardsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewsCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SwipeableCardCell
        let view = dataSource.swipeableCardsView(self, viewForIndex: indexPath.row)
        cell.embedView(view)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.swipeableCardsView(self, didSelectItemAtIndex: indexPath.row)
    }
}
