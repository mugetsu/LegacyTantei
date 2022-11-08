//
//  ScheduleView.swift
//  Tantei
//
//  Created by Randell on 6/11/22.
//

import SnapKit
import UIKit

final class ScheduleView: UIView {
    private let flowLayout = HorizontalSnappingLayout()
    
    private let reuseIdentifier = "scheduleCell"
    
    private var collectionView: UICollectionView!
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.font = UIFont.Custom.regular?.withSize(16)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Schedule for today"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var animes: [Jikan.AnimeDetails] = []
    
    var cellSpacing: CGFloat = 16
    
    var cellPeekWidth: CGFloat = 24
    
    required init(animes: [Jikan.AnimeDetails]) {
        self.animes = animes
        super.init(frame: .zero)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: UI Setup
private extension ScheduleView {
    func configureLayout() {
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = cellSpacing
        flowLayout.snapPosition = .left
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
        collectionView.register(ScheduleCellView.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.bottom.equalTo(snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: UICollectionViewDelegate & UICollectionViewDataSource
extension ScheduleView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ScheduleCellView
        let anime = animes[indexPath.row]
        cell.timeLabel.text = anime.broadcast?.time ?? "00:00"
        cell.titleLabel.text = anime.titles?.first?.title ?? "Test"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = max(0, collectionView.frame.size.width - 2 * (cellSpacing + cellPeekWidth))
        return CGSize(width: itemWidth, height: collectionView.frame.size.height)
    }
}

// MARK: Configuration
extension ScheduleView {
    func scheduleUpdate(with model: [Jikan.AnimeDetails]) {
        animes = model
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .zero
        collectionView.reloadData()
    }
}
