//
//  MainViewContorllerExt.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/9/24.
//

import UIKit


extension MainViewController {
    func extensionFunctions() {
        setupConstraints()
        setupBindings()
    }

    private func setupBindings() {
        bannerSliderView.selectedSliderData
            .subscribe(onNext: { [weak self] (productData, index) in
                self?.handleImageSelection(productData: productData, index: index)
            })
            .disposed(by: disposeBag)
        

         chipsSectionView.chipTapped
             .subscribe(onNext: { [weak self] (index, data) in
                 self?.handleChipSelection(index: index, data: data)
             })
             .disposed(by: disposeBag)
 
 
        [todayPublishingView, hotSNSSection, genreSection, recommendSection].forEach { item in
            item.itemTapped.subscribe(onNext: { [weak self] productData in
                    self?.handleProductItemTapped(productData: productData)
                })
                .disposed(by: disposeBag)
        }
        
        subTitleView1.buttonTapped
            .subscribe(onNext: { [weak self] in
                self?.handleButtonTap()
            })
            .disposed(by: disposeBag)
        
        subTitleViewTodayPublished.buttonTapped
            .subscribe(onNext: { [weak self] in
                self?.handleButtonTap2()
            })
            .disposed(by: disposeBag)
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
    
    private func handleButtonTap2() {

        let alert = UIAlertController(title: "Alert", message: "handleButtonTap2.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    private func handleButtonTap(title: String) {
  
          let alert = UIAlertController(title: "알림", message: "\(title) handleButtonTap.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
          present(alert, animated: true, completion: nil)
      }
      
   func handleBottomButtonTap() {
 
      let alert = UIAlertController(title: "알림", message: "바텀 바 버튼이 눌렸습니다.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
      present(alert, animated: true, completion: nil)
  }
}


extension MainViewController {
    
   func coloredForDebugging() {
       // for debugging
       view.backgroundColor = .systemYellow
       view.safeAreaLayoutGuide.owningView?.backgroundColor = .magenta
       mainScrollView.backgroundColor = .blue
       mainContainerView.backgroundColor = .darkGray
       subTitleViewTodayPublished.backgroundColor = .green
       todayPublishingView.backgroundColor = .systemPink
       subTitleViewHotSNS.backgroundColor = .systemTeal
       todayPublishingView.backgroundColor = .brown
       
       mainBottomInfoBar.backgroundColor = .red
   }
    
    func bottomBarContentConstraints(productInfoView: UIView) {
        NSLayoutConstraint.activate([
            productInfoView.leadingAnchor.constraint(equalTo: mainBottomInfoBar.leadingAnchor),
            productInfoView.trailingAnchor.constraint(equalTo: mainBottomInfoBar.trailingAnchor),
            productInfoView.bottomAnchor.constraint(equalTo: mainBottomInfoBar.bottomAnchor),
            productInfoView.heightAnchor.constraint(equalToConstant: mainBottomInfoBar.frame.height)
        ])
    }
    private func setupConstraints() {
        
       NSLayoutConstraint.activate([
           mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           mainScrollView.topAnchor.constraint(equalTo: view.topAnchor),
           mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           mainScrollView.bottomAnchor.constraint(equalTo: mainBottomInfoBar.topAnchor)
       ])
       

       NSLayoutConstraint.activate([
           mainContainerView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor),
           mainContainerView.leadingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.leadingAnchor),
           mainContainerView.trailingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.trailingAnchor),
           mainContainerView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor),
           mainContainerView.widthAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.widthAnchor)
       ])
       

       NSLayoutConstraint.activate([
        mainContentStackView.topAnchor.constraint(equalTo: mainContainerView.topAnchor),
           mainContentStackView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
           mainContentStackView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
           mainContentStackView.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: -10)
       ])
       
       NSLayoutConstraint.activate([
        mainBottomInfoBar.heightAnchor.constraint(equalToConstant: Dimens.bottomInfoBarHeight),
           mainBottomInfoBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           mainBottomInfoBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           mainBottomInfoBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

       ])
       
       NSLayoutConstraint.activate([
        bannerSliderView.heightAnchor.constraint(equalToConstant: Dimens.bannerSliderHeight)
       ])
       
       NSLayoutConstraint.activate([
            chipsSectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 70)
       ])
       
        NSLayoutConstraint.activate([
            todayPublishingView.heightAnchor.constraint(equalToConstant: Dimens.gridSectionHeight),
            hotSNSSection.heightAnchor.constraint(equalToConstant: Dimens.gridSectionHeight),
            genreSection.heightAnchor.constraint(equalToConstant: Dimens.gridSectionHeight),
            recommendSection.heightAnchor.constraint(equalToConstant: Dimens.gridSectionHeight)
        ])

   }

}
