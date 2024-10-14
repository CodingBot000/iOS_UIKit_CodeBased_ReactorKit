//
//  SubTitleView.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/8/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SubTitleView: UIView {
    
    var disposeBag = DisposeBag()
  
    private let titleLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    
    private let buttonTappedSubject = PublishSubject<Void>()
    var buttonTapped: Observable<Void> {
        return buttonTappedSubject.asObservable()
    }
  
    init(title: String, buttonName: String? = nil, isButtonVisible: Bool = false) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
        setupConstraints()
        configure(title: title, buttonName: buttonName, isButtonVisible: isButtonVisible)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupView() {
 
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .black
        addSubview(titleLabel)
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setTitle("See All", for: .normal)
        actionButton.setTitleColor(.systemGray, for: .normal)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        addSubview(actionButton)
        
        actionButton.rx.tap
            .bind { [weak self] in
                self?.buttonTappedSubject.onNext(())
            }
            .disposed(by: disposeBag)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Dimens.subTitleViewPadding)
            make.centerY.equalToSuperview()
        }

        actionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(Dimens.subTitleViewPadding * -1)
            make.centerY.equalToSuperview()
        }
    }

    private func configure(title: String, buttonName: String?, isButtonVisible: Bool) {
        titleLabel.text = title
        
        if let buttonName = buttonName, !buttonName.isEmpty {
            actionButton.setTitle(buttonName, for: .normal)
        } else {
            actionButton.setTitle("전체보기", for: .normal)
        }
        
        actionButton.isHidden = !(isButtonVisible && !(buttonName ?? "").isEmpty)
    }
}
