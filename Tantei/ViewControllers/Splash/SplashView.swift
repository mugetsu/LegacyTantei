//
//  SplashView.swift
//  Tantei
//
//  Created by Randell on 11/3/23.
//

import UIKit
import SnapKit

class SplashView: UIViewController {
    required init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var contentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alpha = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "detective")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Tantei"
        label.font = UIFont.Custom.medium?.withSize(26)
        label.textColor = UIColor.Illustration.highlight
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [weak self] in
            guard let self = self else { return }
            self.transitionToNewRootViewController(
                with: MainCoordinator().dashboardCoordinator.start()
            )
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4) { [weak self] in
                guard let self = self else { return }
                self.contentView.alpha = 1.0
            }
        }
    }
}

// MARK: UI Setup
private extension SplashView {
    func configureView() {
        view.backgroundColor = UIColor.Elements.backgroundDark
        view.addSubview(contentView)
        contentView.addArrangedSubview(imageView)
        contentView.addArrangedSubview(titleLabel)
        contentView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
