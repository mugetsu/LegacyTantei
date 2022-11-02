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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        label.textColor = .black
        label.font = .systemFont(ofSize: 34)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(labelTap)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        }
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        delegate?.didSelectItem(at: index)
        labelAnimation(index, item: titleStackView.arrangedSubviews[index])
    }
    
    func labelAnimation(_ index: Int, item: UIView) {
        if index != 0 {
            let oov = self.titles[0..<index]
            let range = 0...(oov.count-1)
            self.titles.append(contentsOf: oov)
            if let label = titleStackView.arrangedSubviews[0] as? UILabel {
                UIView.transition(with: label, duration: 0.26, options: .transitionCrossDissolve) {
                    label.textColor = UIColor("#7f5af0", alpha: 0.2)
                }
            }
            titleStackView.snp.updateConstraints {
                $0.left.equalToSuperview().offset(-(item.frame.minX))
            }
            UIView.animate(withDuration: 0.4) {
                self.layoutIfNeeded()
            } completion: { _ in
                self.titles.removeSubrange(range)
                self.titleStackView.snp.updateConstraints {
                    $0.left.equalToSuperview()
                }
                self.updateLabels()
            }
        }
    }
    
    func updateLabels() {
        self.titleStackView.arrangedSubviews.enumerated().forEach { (index, item) in
            if let label = self.titleStackView.arrangedSubviews[index] as? UILabel {
                label.tag = index
                label.text = self.titles[index]
                if index == 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        UIView.transition(
                            with: label,
                            duration: 0.26,
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
