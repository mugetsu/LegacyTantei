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
        stackView.spacing = 16
        stackView.layer.masksToBounds = false
        stackView.layer.shadowOpacity = 0.30
        stackView.layer.shadowRadius = 4
        stackView.layer.shadowOffset = CGSize(width: 0, height: 4)
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.cornerRadius = 4
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(contentStackView)
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    var animes: [Jikan.AnimeDetails] = []
    
    required init(animes: [Jikan.AnimeDetails]) {
        self.animes = animes
        super.init(frame: .zero)
        configureView(with: animes)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Configuration
extension ScheduleView {
    func configureView(with animes: [Jikan.AnimeDetails]) {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview()
        }
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(scrollView)
            $0.leading.trailing.equalTo(scrollView)
            $0.height.equalTo(scrollView)
        }
        animes.enumerated().forEach { index, anime in
            guard let titles = anime.titles?.last(where: { $0.type == "Default" || $0.type == "English" }),
                  let title = titles.title
            else {
                return
            }
            let label = UILabel()
            let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
            label.tag = index
            label.text = title
            label.font = UIFont.Custom.bold?.withSize(26)
            label.textColor = .white
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(labelTap)
            label.translatesAutoresizingMaskIntoConstraints = false
            contentStackView.addArrangedSubview(label)
        }
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        print("Pressed: \(index)")
    }
}
