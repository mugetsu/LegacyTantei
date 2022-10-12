//
//  DetailView.swift
//  Tantei-san
//
//  Created by Randell on 12/10/22.
//

import UIKit
import SnapKit

final class DetailView: UIViewController {
    internal let anime: TopAnime
    
    required init(anime: TopAnime) {
        self.anime = anime
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Custom.bold?.withSize(26)
        label.textColor = UIColor.Elements.headline
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureData(using: anime)
        configureLayout()
    }
    
    func configureData(using model: TopAnime) {
        titleLabel.text = model.title
    }
    
    func configureLayout() {
        view.backgroundColor = UIColor.Elements.backgroundDark
        view.addSubview(titleLabel)
        view.subviews.forEach {
            $0.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16.0)
            }
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
        }
    }
}
