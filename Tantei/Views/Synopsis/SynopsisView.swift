//
//  SynopsisView.swift
//  Tantei
//
//  Created by Randell Quitain on 26/3/23.
//

import SnapKit
import UIKit

final class SynopsisView: UIStackView {
    
    var synopsis: String = ""
    
    required init(synopsis: String) {
        self.synopsis = synopsis
        super.init(frame: .zero)
        configureLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Custom.medium?.withSize(17)
        label.textColor = UIColor.Elements.cardParagraph
        label.numberOfLines = 4
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var expandButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .clear
        button.setTitleColor(UIColor.Illustration.highlight, for: .normal)
        button.setTitle("read more", for: .normal)
        button.titleLabel?.font = UIFont.Custom.medium?.withSize(17)
        button.addTarget(self, action: #selector(onExpand), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}

// MARK: UI Setup
private extension SynopsisView {
    func configureLayout() {
        guard !synopsis.isEmpty else {
            isHidden = true
            return
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(onExpand))
        isHidden = false
        axis = .vertical
        alignment = .leading
        distribution = .fill
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
        translatesAutoresizingMaskIntoConstraints = false
        contentLabel.text = synopsis
        addArrangedSubview(contentLabel)
        addArrangedSubview(expandButton)
    }
}

// MARK: Actions
extension SynopsisView {
    @objc func onExpand() {
        let isExpanded = contentLabel.numberOfLines == 0
        contentLabel.numberOfLines = isExpanded ? 4 : 0
        expandButton.setTitle(isExpanded ? "read more" : "read less", for: .normal)
        contentLabel.superview?.layoutIfNeeded()
    }
}

// MARK: Configuration
extension SynopsisView {
    func update(with model: String) {
        synopsis = model
        configureLayout()
    }
}
