//
//  ProductInfoView.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/10/24.
//

import UIKit
import RxSwift


class ProductInfoView: UIView {
    
    enum HistoryState {
        case empty
        case notEmpty
    }

    var disposeBag = DisposeBag()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let manufacturerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let masterStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
//        stack.backgroundColor = .systemGray
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "play.circle")
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let prevButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "backward.circle")
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "forward.circle")
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    var onPlayButtonTapped: ((ProductData) -> Void)?
    var onPrevButtonTapped: (() -> Void)?
    var onNextButtonTapped: (() -> Void)?
    
    init(productData: ProductData) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
        setupConstraints()
        configure(with: productData)
        bindAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindAction() {
        MemoryStores.historyChagneObservable
            .subscribe(onNext: { [weak self] (index, data ) in
                print("appLog MemoryStores.historyChagneObservable data:\(data.name)")
                self?.configure(with: data)
        })
        .disposed(by: disposeBag)
        
    }
    
    private func setupView() {
        backgroundColor = .systemGray6
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(containerView)
        
        containerView.addSubview(masterStackView)
        
        descStackView.addArrangedSubview(nameLabel)
        descStackView.addArrangedSubview(manufacturerLabel)
        
        
        masterStackView.addArrangedSubview(productImageView)
        masterStackView.addArrangedSubview(descStackView)
        masterStackView.addArrangedSubview(playButton)
    
        
        [productImageView, descStackView, prevButton, playButton, nextButton].forEach { makeView in
            masterStackView.addArrangedSubview(makeView)
        }
        
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(prevButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
//        coloredForDebugging()
    }
    
    private func configure(with productData: ProductData) {
        let state: HistoryState = productData.id.isEmpty ? .empty : .notEmpty
        
        if state == .empty {
            nameLabel.text = "Empty History"
            manufacturerLabel.text = ""
            productImageView.image = nil
        } else {
            nameLabel.text = productData.name
            manufacturerLabel.text = productData.manufacturer
            productImageView.image = UIImage(named: productData.imageName)
        }
        
        colorChange(state: state)
        buttonStateChange()
    }
    
    private func colorChange(state: HistoryState) {
        nameLabel.textColor = getNameColor(state: state)
        manufacturerLabel.textColor = getManufacturerNameColor(state: state)
    }
    
    private func buttonStateChange() {
        print("appLog buttonStateChange")
        prevButton.isEnabled = MemoryStores.isCanPrev()
        nextButton.isEnabled = MemoryStores.isCanNext()
        playButton.isEnabled = MemoryStores.isCanPlay()
    }
    
    private func getNameColor(state: HistoryState) -> UIColor {
        switch state {
        case .empty:
            return .systemGray2
        case .notEmpty:
            return .black
        }
    }
    
    private func getManufacturerNameColor(state: HistoryState) -> UIColor {
        switch state {
        case .empty:
            return .systemGray3
        case .notEmpty:
            return .black
        }
    }
    
    // MARK: - Actions
    @objc private func playButtonTapped() {
        let currentProduct = MemoryStores.currentProdcutHistory()
        onPlayButtonTapped?(currentProduct)
    }
    
    @objc private func prevButtonTapped() {
        MemoryStores.prevProdcutHistory()
        onPrevButtonTapped?()
    }
    
    @objc private func nextButtonTapped() {
        MemoryStores.nextProdcutHistory()
        onNextButtonTapped?()
    }

}

extension ProductInfoView {
    private func setupConstraints() {
        NSLayoutConstraint.activate([

            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimens.containerPadding),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Dimens.containerPadding * -1),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: Dimens.containerPadding),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Dimens.containerPadding * -1),
            containerView.heightAnchor.constraint(equalToConstant: Dimens.containerHeight),
            
            masterStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            masterStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            masterStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            masterStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            productImageView.widthAnchor.constraint(equalToConstant: Dimens.productImageSize),
            productImageView.heightAnchor.constraint(equalToConstant: Dimens.productImageSize),
            
            playButton.widthAnchor.constraint(equalToConstant: Dimens.playButtonSize),
            playButton.heightAnchor.constraint(equalToConstant: Dimens.playButtonSize),
            prevButton.widthAnchor.constraint(equalToConstant: Dimens.prevForwardButtonSize),
            prevButton.heightAnchor.constraint(equalToConstant: Dimens.prevForwardButtonSize),
            nextButton.widthAnchor.constraint(equalToConstant: Dimens.prevForwardButtonSize),
            nextButton.heightAnchor.constraint(equalToConstant: Dimens.prevForwardButtonSize)
        ])

    }
    
    private func coloredForDebugging() {

        nameLabel.textColor = .systemGray2
        manufacturerLabel.textColor = .systemGray3
        descStackView.backgroundColor = .systemGray
        containerView.backgroundColor = .magenta
        masterStackView.backgroundColor = .systemGray
    }
}
