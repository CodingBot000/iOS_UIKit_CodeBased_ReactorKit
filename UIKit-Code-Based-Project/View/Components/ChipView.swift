//
//  ChipView.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/8/24.
//

import UIKit
import RxSwift
import RxCocoa

class ChipView: UIView {

    private let index: Int
    private let data: ChipData
    private let backgroundColorCustom: UIColor

    private let button = UIButton(type: .system)

    private let tapSubject = PublishSubject<(Int, ChipData)>()
    var tapObservable: Observable<(Int, ChipData)> {
        return tapSubject.asObservable()
    }

    init(index: Int, data: ChipData, backgroundColor: UIColor) {
        self.index = index
        self.data = data
        self.backgroundColorCustom = backgroundColor
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {

        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.title = data.name
            config.baseBackgroundColor = backgroundColorCustom
            config.baseForegroundColor = .black
            config.cornerStyle = .medium
            config.contentInsets = NSDirectionalEdgeInsets(
                top: Dimens.chipViewVerticalInsets,
                leading: Dimens.chipViewhorizontalInsets,
                bottom: Dimens.chipViewVerticalInsets,
                trailing: Dimens.chipViewhorizontalInsets)
            button.configuration = config
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.lineBreakMode = .byClipping
        } else {

            button.setTitle(data.name, for: .normal)
            button.titleLabel?.font = button.titleLabel?.font.withSize(13)
            button.tintColor = .black
            button.backgroundColor = backgroundColorCustom
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 8
            button.clipsToBounds = true
            button.contentEdgeInsets = UIEdgeInsets(
                top: Dimens.chipViewVerticalInsets,
                left: Dimens.chipViewhorizontalInsets,
                bottom: Dimens.chipViewVerticalInsets,
                right: Dimens.chipViewhorizontalInsets)

            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.lineBreakMode = .byClipping
        }

        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        addSubview(button)
    }

    @objc private func buttonTapped() {
        tapSubject.onNext((index, data))
    }
}

extension ChipView {

    private func setupConstraints() {
       button.snp.makeConstraints { make in
           make.top.equalToSuperview().offset(Dimens.chipViewMargin)
           make.leading.equalToSuperview().offset(Dimens.chipViewMargin)
           make.trailing.equalToSuperview().offset(-Dimens.chipViewMargin)
           make.bottom.equalToSuperview().offset(-Dimens.chipViewMargin)
       }

       button.setContentHuggingPriority(.required, for: .horizontal)
       button.setContentCompressionResistancePriority(.required, for: .horizontal)

       self.setContentHuggingPriority(.required, for: .horizontal)
       self.setContentCompressionResistancePriority(.required, for: .horizontal)
   }
}

