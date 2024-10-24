//
//  DetailViewController.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/10/24.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class DetailViewController: UIViewController, View {
    
    typealias Reactor = DetailViewReactor
    var disposeBag = DisposeBag()
    
    private let customNavBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "arrow.left")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Detail"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "heart")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        // view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let verticalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 3
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let descScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = true
        sv.alwaysBounceHorizontal = false
        sv.alwaysBounceVertical = true
        sv.isScrollEnabled = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
   
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private let manufacturerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false

        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    private let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "fill.info")
        
        button.setTitle("More Info", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        label.textColor = .systemGray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0 // 멀티라인 허용
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
 
    init(id: String) {
  
        super.init(nibName: nil, bundle: nil)
        self.reactor = DetailViewReactor(id: id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.navigationController?.setNavigationBarHidden(true, animated: animated)
     }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupViews()
        setupConstraints()
        bindActions()
    }
    
  
    private func setupViews() {
    
        view.addSubview(customNavBar)
        
        customNavBar.addSubview(backButton)
        customNavBar.addSubview(titleLabel)
        customNavBar.addSubview(likeButton)
     
        view.addSubview(contentView)
        contentView.addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(productImageView)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(moreInfoButton)
        verticalStackView.addArrangedSubview(manufacturerLabel)

         verticalStackView.addArrangedSubview(descScrollView)

         descScrollView.addSubview(descLabel)

//        coloredDebug()
    }
 
    
    func bind(reactor: DetailViewReactor) {
            
            likeButton.rx.tap
                .map { Reactor.Action.toggleLike }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)

            reactor.state.map { $0.isLiked }
                .distinctUntilChanged()
                .bind { [weak self] isLiked in
                    guard let self = self else { return }

                    let imageName = isLiked ? "heart.fill" : "heart"
                    
                    self.likeButton.setImage(UIImage(systemName: imageName), for: .normal)
                    self.likeButton.accessibilityIdentifier = isLiked ? "liked" : "unliked"
                    self.likeButton.accessibilityLabel = isLiked ? "Unlike" : "Like"
                }
                .disposed(by: disposeBag)

            reactor.state.map { $0.productData }
                .distinctUntilChanged()
                .bind { [weak self] productData in
                    self?.configure(with: productData)
                }
                .disposed(by: disposeBag)
        }
 
    private func bindActions() {
    
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handleBackButton()
            })
            .disposed(by: disposeBag)
        
        moreInfoButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handlWebViewOpen()
            } )
            .disposed(by: disposeBag)
    }
    

    private func handleBackButton() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func handlWebViewOpen() {
        guard let productData = reactor?.currentState.productData,
            let url = URL(string: productData.infoUrl) else { return }
        let webVC = WebViewController(url: url)
        navigationController?.pushViewController(webVC, animated: true)

    }
    
  
    private func configure(with productData: ProductData?) {
        if let productData = productData {
            productImageView.image = UIImage(named: productData.imageName)
            nameLabel.text = productData.name
            manufacturerLabel.text = productData.manufacturer
            descLabel.text = productData.description
        } else {
            productImageView.image = nil
            nameLabel.text = "Product Load Error"
            manufacturerLabel.text = ""
            descLabel.text = ""
        }
    }
    
    
    private func coloredDebug() {
        verticalStackView.backgroundColor = .magenta
        manufacturerLabel.backgroundColor = .red
        descScrollView.backgroundColor = .blue
        descLabel.backgroundColor = .green
    }
    private func setupConstraints() {
   
        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBar.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([

            backButton.leadingAnchor.constraint(equalTo: customNavBar.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: customNavBar.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: Dimens.detailViewPadding),
            backButton.heightAnchor.constraint(equalToConstant: Dimens.detailViewPadding)
        ])
        
        NSLayoutConstraint.activate([
         
            likeButton.trailingAnchor.constraint(equalTo: customNavBar.trailingAnchor, constant: -16),
            likeButton.centerYAnchor.constraint(equalTo: customNavBar.centerYAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: Dimens.detailViewPadding),
            likeButton.heightAnchor.constraint(equalToConstant: Dimens.detailViewPadding)
        ])
        
        NSLayoutConstraint.activate([
     
            titleLabel.centerXAnchor.constraint(equalTo: customNavBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: customNavBar.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([

            contentView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
         
        ])
        
        NSLayoutConstraint.activate([

            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

             verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
 
        productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor, multiplier: 9.0/16.0).isActive = true
        
        NSLayoutConstraint.activate([
            descLabel.topAnchor.constraint(equalTo: descScrollView.topAnchor),
            descLabel.leadingAnchor.constraint(equalTo: descScrollView.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: descScrollView.trailingAnchor),
            descLabel.bottomAnchor.constraint(equalTo: descScrollView.bottomAnchor),
            descLabel.widthAnchor.constraint(equalTo: descScrollView.widthAnchor)
        ])
        descScrollView.setContentHuggingPriority(.defaultLow, for: .vertical)
        descScrollView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

    }
}
//
//#if DEBUG
//import SwiftUI
//struct DetailViewControllerRepresentable: UIViewControllerRepresentable {
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//    }
//    
//    @available(iOS 13.0, *)
//    func makeUIViewController(context: Context) -> UIViewController {
//
//        DetailViewController(productData: ProductData(id: "1", name: "ABCDE", subName: "subNameee", manufacturer: "manufacturer", description: "asddf asdffasddf asddf as asdffasddffasddf asdasdffasddf asddf asdffasddf asddf as asdffasddffasddf asdasdffasddf asddf asdffasddf asddf as asdffasddffasddf asdasdffasddf asddf asdffasddf asddf as asdffasddffasddf asdasdffasddf asddf asdffasddf asddf as asdffasddffasddf asdasdffasddf asddf asdffasddf asddf as asdffasddffasddf asdasdffasddf asddf asdffasddf asddf as asdffasddffasddf asdasdffasddf asddf asdffasddf asddf as asdffasddffasddf asdasdffasddf asddf asdffasddf asddf as asdffasddffasddf asdasdffasddf asddf asdffasddf asddf as asdffasddffasddf asdasdffasddf asddf asdffasddf asddf as asdffasddffasddf asdasdffasddf asddf asdffasddf asddf as asdffasddffasddf asdasdffasddf ", isHybrid: false, infoUrl: "https://www.naver.com", imageName: "sonata"))
//    }
//}
//
//struct DetailViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailViewControllerRepresentable()
//            .previewDisplayName("아이폰 11")
//    }
//}
//#endif
