//
//  MenuView.swift
//  Tantei
//
//  Created by Randell Quitain on 23/4/23.
//

import Combine
import Foundation
import SnapKit
import UIKit

final class MenuView: UIView {
    
    required init() {
        super.init(frame: .zero)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .horizontal
        view.spacing = 0
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

// MARK: UI Setup
private extension MenuView {
    func configureLayout() {
        backgroundColor = UIColor.Elements.backgroundDark
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
}
