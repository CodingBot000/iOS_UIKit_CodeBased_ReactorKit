//
//  MainCollectionViewController.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/14/24.
//

import UIKit
import RxSwift
import RxCocoa

class MainCollectionViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    let collectionView: UICollectionView
    let mainBottomInfoBar = UIView()
    
    let collectionItems: [MainCollectionViewCellType] = [
        .banner,
        .chipsSection,
        .gridSection(title: "Today Publishing Product", buttonName: nil, isButtonVisible: false, repositoryDataType: .Today, gridType: .rectangle),
        .gridSection(title: "Hot SNS", buttonName: nil, isButtonVisible: false, repositoryDataType: .HotNews, gridType: .rectangle),
        .gridSection(title: "Genre", buttonName: nil, isButtonVisible: false, repositoryDataType: .Genre, gridType: .wideWidth),
        .gridSection(title: "Recommend", buttonName: nil, isButtonVisible: false, repositoryDataType: .Recommend, gridType: .rectangle)
    ]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)
        collectionView.register(ChipsSectionCell.self, forCellWithReuseIdentifier: ChipsSectionCell.identifier)
        collectionView.register(GridSectionCell.self, forCellWithReuseIdentifier: GridSectionCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.showsVerticalScrollIndicator = true
        collectionView.alwaysBounceVertical = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupSubviews()
        
        collectionView.contentInsetAdjustmentBehavior = .never
//        if let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height {
//            collectionView.contentInset.top = statusBarHeight
//            collectionView.scrollIndicatorInsets.top = statusBarHeight
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//    }
//    
    private func setupSubviews() {
        view.addSubview(collectionView)
        view.addSubview(mainBottomInfoBar)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        mainBottomInfoBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: mainBottomInfoBar.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            mainBottomInfoBar.heightAnchor.constraint(equalToConstant: Dimens.bottomInfoBarHeight),
            mainBottomInfoBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainBottomInfoBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainBottomInfoBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        setupBottomInfoBar()
//        coloredForDebugging()
    }
    
   func coloredForDebugging() {
       // for debugging
       view.backgroundColor = .systemYellow
       view.safeAreaLayoutGuide.owningView?.backgroundColor = .magenta
       collectionView.backgroundColor = .blue
       
       mainBottomInfoBar.backgroundColor = .red
   }
    private func setupBottomInfoBar() {
        let product = MemoryStores.currentProdcutHistory()
        let productInfoView = ProductInfoView(productData: product)
        
        productInfoView.onPlayButtonTapped = { [weak self] (data) in
            if (!data.id.isEmpty) {
                self?.gotoDetailViewController(productData: data)
            }
        }

        mainBottomInfoBar.addSubview(productInfoView)
        productInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productInfoView.leadingAnchor.constraint(equalTo: mainBottomInfoBar.leadingAnchor),
            productInfoView.trailingAnchor.constraint(equalTo: mainBottomInfoBar.trailingAnchor),
            productInfoView.bottomAnchor.constraint(equalTo: mainBottomInfoBar.bottomAnchor),
            productInfoView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func handleImageSelection(productData: ProductData, index: Int) {
        gotoDetailViewController(productData: productData)
        print("Selected Image Index: \(productData), Image: \(productData.imageName)")
    }
    
    private func handleChipSelection(index: Int, data: ChipData) {
        print("Selected Chip Index: \(index), Chip: \(data)")
    }
    
    private func handleProductItemTapped(productData: ProductData) {
        gotoDetailViewController(productData: productData)
        print("Tapped Product: \(productData.name)")
    }
    
    private func handleButtonTap() {
        let alert = UIAlertController(title: "Alert", message: "handleButtonTap.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func handleButtonTap(title: String) {
        let alert = UIAlertController(title: "Alert", message: "\(title) handleButtonTap.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

// MARK: - UICollectionViewDataSource

extension MainCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = collectionItems[indexPath.item]

        switch item {
        case .banner:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier, for: indexPath) as! BannerCell
            cell.selectedSliderData
                .subscribe(onNext: { [weak self] (productData, index) in
                    self?.handleImageSelection(productData: productData, index: index)
                })
                .disposed(by: cell.disposeBag)
            return cell

        case .chipsSection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChipsSectionCell.identifier, for: indexPath) as! ChipsSectionCell
            cell.chipTapped
                .subscribe(onNext: { [weak self] (index, data) in
                    self?.handleChipSelection(index: index, data: data)
                })
                .disposed(by: cell.disposeBag)
            cell.subTitleViewButtonTapped
                .subscribe(onNext: { [weak self] in
                    self?.handleButtonTap()
                })
                .disposed(by: cell.disposeBag)
            return cell

        case .gridSection(let title, let buttonName, let isButtonVisible, let repositoryDataType, let gridType):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridSectionCell.identifier, for: indexPath) as! GridSectionCell
            cell.configure(title: title, buttonName: buttonName, isButtonVisible: isButtonVisible, repositoryDataType: repositoryDataType, gridType: gridType)
            cell.itemTapped
                .subscribe(onNext: { [weak self] productData in
                    self?.handleProductItemTapped(productData: productData)
                })
                .disposed(by: cell.disposeBag)
            cell.buttonTapped
                .subscribe(onNext: { [weak self] in
                    self?.handleButtonTap(title: title)
                })
                .disposed(by: cell.disposeBag)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let item = collectionItems[indexPath.item]
        let width = collectionView.bounds.width

        switch item {
        case .banner:
            return CGSize(width: width, height: Dimens.bannerSliderHeight)
        case .chipsSection:
            let subTitleHeight: CGFloat = Dimens.subTitleViewHeight
            let chipsHeight: CGFloat = 70
            let totalHeight = subTitleHeight + chipsHeight
            return CGSize(width: width, height: totalHeight)

        case .gridSection:
            let subTitleHeight: CGFloat = Dimens.subTitleViewHeight
            let gridHeight: CGFloat = Dimens.gridSectionHeight
            let totalHeight = subTitleHeight + gridHeight
            return CGSize(width: width, height: totalHeight)
        }
    }
}
