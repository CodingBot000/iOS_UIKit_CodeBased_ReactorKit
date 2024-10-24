//
//  HorizontalGridScrollView.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/8/24.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class HorizontalGridScrollView: UIView, View {

    typealias Reactor = HorizontalGridScrollReactor
    var disposeBag = DisposeBag()

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceHorizontal = true
        sv.alwaysBounceVertical = false
        sv.isScrollEnabled = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fillProportionally
        sv.spacing = 15
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private var gridType: GridType
    
    private let itemTappedSubject = PublishSubject<ProductData>()
    
    var itemTapped: Observable<ProductData> {
        return itemTappedSubject.asObservable()
    }
    
    init(frame: CGRect, repositoryDataType: RepositoryDataType, gridType: GridType) {
        self.gridType = gridType
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
        setupConstraints()
        setUpReactor(repositoryDataType: repositoryDataType)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func setUpReactor(repositoryDataType: RepositoryDataType) {
         let repository: ProductRepositoryProtocol
         
         switch repositoryDataType {
             case .Today:
                 repository = TodayProductRepositoryImpl()
             case .Recommend:
                 repository = RecommendRepositoryImpl()
             case .HotNews:
                repository = HotNewsRepositoryImpl()
             case .Genre:
                repository = GenreRepositoryImpl()
         }
         
         self.reactor = HorizontalGridScrollReactor(productRepository: repository)
         self.reactor?.action.onNext(.fetchDataList)
     }
    
 
    private func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
    }


    func bind(reactor: Reactor) {
        reactor.state.map { $0.products }
            .distinctUntilChanged()
            .bind { [weak self] products in
                self?.setupItems(products: products)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupItems(products: [ProductData]) {

        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for product in products {
            let itemView = GridImageItemViewCell(productData: product, gridType: gridType)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(itemView)

            itemView.tapObservable
                .bind { [weak self] productData in
                    self?.itemTappedSubject.onNext(productData)
                }
                .disposed(by: disposeBag)
        }
        
        layoutIfNeeded()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
}
