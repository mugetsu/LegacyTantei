//
//  HorizontalSnappingLayout.swift
//  Tantei
//
//  Created by Randell on 3/11/22.
//

import Foundation
import UIKit

final class HorizontalSnappingLayout: UICollectionViewFlowLayout {
    enum SnapPositionType: Int {
        case left,
             center,
             right
    }
    var snapPosition = SnapPositionType.center
    
    let minimumSnapVelocity: CGFloat = 0.3
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(
                forProposedContentOffset: proposedContentOffset,
                withScrollingVelocity: velocity
            )
        }
        var offsetAdjusment = CGFloat.greatestFiniteMagnitude
        let horizontalPosition: CGFloat
        switch snapPosition {
        case .left:
            horizontalPosition = proposedContentOffset.x + collectionView.contentInset.left + sectionInset.left
        case .center:
            horizontalPosition = proposedContentOffset.x + (collectionView.bounds.width * 0.5)
        case .right:
            horizontalPosition = proposedContentOffset.x + collectionView.bounds.width - sectionInset.right
        }
        let targetRect = CGRect(
            x: proposedContentOffset.x,
            y: 0,
            width: collectionView.bounds.size.width,
            height: collectionView.bounds.size.height
        )
        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
        layoutAttributesArray?.forEach { layoutAttributes in
            let itemHorizontalPosition: CGFloat
            switch snapPosition {
            case .left:
                itemHorizontalPosition = layoutAttributes.frame.minX - collectionView.contentInset.left
            case .center:
                itemHorizontalPosition = layoutAttributes.center.x
            case .right:
                itemHorizontalPosition = layoutAttributes.frame.maxX + collectionView.contentInset.right
            }
            if abs(itemHorizontalPosition - horizontalPosition) < abs(offsetAdjusment) {
                if abs(velocity.x) < self.minimumSnapVelocity {
                    offsetAdjusment = itemHorizontalPosition - horizontalPosition
                } else if velocity.x > 0 {
                    offsetAdjusment = itemHorizontalPosition - horizontalPosition + (layoutAttributes.bounds.width + self.minimumLineSpacing)
                } else {
                    offsetAdjusment = itemHorizontalPosition - horizontalPosition - (layoutAttributes.bounds.width + self.minimumLineSpacing)
                }
            }
        }
        return CGPoint(x: proposedContentOffset.x + offsetAdjusment, y: proposedContentOffset.y)
    }
}
