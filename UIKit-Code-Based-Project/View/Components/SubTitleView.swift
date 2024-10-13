//
//  SubTitleView.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/8/24.
//

import UIKit
import RxSwift
import RxCocoa

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
        NSLayoutConstraint.activate([

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: actionButton.leadingAnchor, constant: -8)
        ])
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
