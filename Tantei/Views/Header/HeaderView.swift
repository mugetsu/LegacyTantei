//
//  HeaderView.swift
//  Tantei
//
//  Created by Randell on 30/10/22.
//

import Combine
import Foundation
import SnapKit
import UIKit

final class HeaderView: UIView {
    private let viewModel: HeaderViewModel
    
    private var uiEvent = PassthroughSubject<HeaderEvents.UIEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    var delegate: HeaderViewDelegate?
    
    required init(viewModel: HeaderViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureLayout()
        viewModel.bind(uiEvent.eraseToAnyPublisher())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case let .showGreeting(message):
                    self.titleLabel.text = message
                case let .showMenu(menuItems):
                    self.delegate?.menuDidTapped(menuItems)
                }
            }.store(in: &cancellables)
        uiEvent.send(.initialized)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var wrapperView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .vertical
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .horizontal
        view.spacing = 0
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "detective-purple")
        let imageTap = UITapGestureRecognizer(
            target: self,
            action: #selector(imageTapped)
        )
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageTap)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.font = UIFont.Custom.extraBold?.withSize(34)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

// MARK: UI Setup
private extension HeaderView {
    func configureLayout() {
        addSubview(wrapperView)
        wrapperView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        wrapperView.addArrangedSubview(contentView)
        wrapperView.addArrangedSubview(UIView.spacer(size: 16, for: .vertical))
        contentView.addArrangedSubview(titleLabel)
        contentView.addArrangedSubview(UIView())
        contentView.addArrangedSubview(imageView)
        imageView.snp.makeConstraints {
            $0.width.equalTo(32)
            $0.height.equalTo(32)
        }
    }
}

// MARK: Actions
private extension HeaderView {
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        uiEvent.send(.menuTapped)
    }
}
