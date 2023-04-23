//
//  SwipeableCardCellView.swift
//  Tantei
//
//  Created by Randell on 9/10/22.
//

import Foundation
import UIKit
import SnapKit

class SwipeableCardCellView: UICollectionViewCell {
    private (set) weak var embededView: UIView?

    func embedView(_ view: SwipeableCard) {
        contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
        embededView = view
    }

    override func prepareForReuse() {
        (embededView as! SwipeableCard).prepareForReuse()
    }
}
