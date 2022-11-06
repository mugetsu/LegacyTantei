//
//  ScheduleView.swift
//  Tantei
//
//  Created by Randell on 6/11/22.
//

import Foundation
import SnapKit
import UIKit

final class ScheduleView: UIView {
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.layer.masksToBounds = false
        stackView.layer.shadowOpacity = 0.30
        stackView.layer.shadowRadius = 4
        stackView.layer.shadowOffset = CGSize(width: 0, height: 4)
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.cornerRadius = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    required init(model: HeaderDetail) {
        super.init(frame: .zero)
//        configure(using: model)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI Setup
private extension ScheduleView {
    func configureLayout() {
        
    }
}

// MARK: Configuration
extension ScheduleView {
//    func configure(using model: ) {
//
//    }
}
