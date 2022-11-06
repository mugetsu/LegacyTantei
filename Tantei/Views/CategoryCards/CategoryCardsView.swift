//
//  CategoryCardsView.swift
//  Tantei
//
//  Created by Randell on 1/11/22.
//

import SnapKit
import UIKit

class CategoryCardsView: UIView {
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let anchorIndex: Int = 0
    
    var titles: [String] = []
    
    var delegate: CategoryCardsViewDelegate?
    
    required init(titles: [String]) {
        self.titles = titles
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI Setup
private extension CategoryCardsView {
    func configureView() {
        addSubview(titleStackView)
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        titles.enumerated().forEach { index, title in
            let label = UILabel()
            let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
            label.tag = index
            label.text = title
            label.font = UIFont.Custom.bold?.withSize(34)
            label.textColor = index == 0
                ? UIColor("#7f5af0", alpha: 1.0)
                : UIColor("#7f5af0", alpha: 0.2)
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(labelTap)
            label.translatesAutoresizingMaskIntoConstraints = false
            titleStackView.addArrangedSubview(label)
            label.snp.makeConstraints {
                $0.bottom.equalTo(titleStackView.snp.bottom)
            }
        }
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        delegate?.didSelect(label: titles[index])
        labelAnimation(index)
    }
    
    func labelAnimation(_ index: Int) {
        if index != anchorIndex {
            let titleSubviews = titleStackView.arrangedSubviews
            let selected = titleSubviews[index]
            let oov = titles[anchorIndex..<index]
            let range = anchorIndex...(oov.count-1)
            titles.append(contentsOf: oov)
            if let label = titleStackView.arrangedSubviews[anchorIndex] as? UILabel {
                UIView.transition(
                    with: label,
                    duration: 0.2,
                    options: .transitionCrossDissolve
                ) {
                    label.textColor = UIColor("#7f5af0", alpha: 0.2)
                }
            }
            titleStackView.snp.updateConstraints {
                $0.left.equalToSuperview().offset(-(selected.frame.minX))
            }
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            } completion: { [weak self] _ in
                guard let self = self else { return }
                self.titles.removeSubrange(range)
                self.titleStackView.snp.updateConstraints {
                    $0.left.equalToSuperview()
                }
                self.updateLabels()
            }
        }
    }
    
    func updateLabels() {
        let titleSubviews = titleStackView.arrangedSubviews
        titleSubviews.enumerated().forEach { [weak self] (index, item) in
            guard let self = self else { return }
            if let label = titleSubviews[index] as? UILabel {
                label.tag = index
                label.text = self.titles[index]
                if index == anchorIndex {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        UIView.transition(
                            with: label,
                            duration: 0.2,
                            options: .transitionCrossDissolve
                        ) {
                            label.textColor = UIColor("#7f5af0", alpha: 1.0)
                        }
                    }
                }
            }
        }
    }
}
