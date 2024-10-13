


import UIKit
import RxSwift


class MainViewController: UIViewController {
    
    let mainScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = true
        sv.alwaysBounceHorizontal = false
        sv.alwaysBounceVertical = true
        sv.isScrollEnabled = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let mainContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mainContentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .equalSpacing
        sv.spacing = 20
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let mainBottomInfoBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let bannerSliderView = ImageSliderView()

    let subTitleView1 = SubTitleView(title: "What you like", buttonName: "See All", isButtonVisible: true)
    let specialChipsSectionView = SpecialChipsSectionView(frame: .zero)
    
    let subTitleViewTodayPublished = SubTitleView(title: "Today Publishing Product", isButtonVisible: false)
    let todayPublishingView =
    HorizontalGridScrollView(frame: .zero, repositoryDataType: RepositoryDataType.Today, gridType: GridType.rectangle)
    
    let subTitleViewHotSNS = SubTitleView(title: "Hot SNS", isButtonVisible: false)
    let hotSNSSection =
    HorizontalGridScrollView(frame: .zero, repositoryDataType: RepositoryDataType.HotNews, gridType: GridType.rectangle)
    
    let subTitleViewGenre = SubTitleView(title: "Genre", isButtonVisible: false)
    let genreSection =
    HorizontalGridScrollView(frame: .zero, repositoryDataType: RepositoryDataType.Genre, gridType: GridType.wideWidth)
    
    
    let subTitleViewRecommend = SubTitleView(title: "Recommend", isButtonVisible: false)
    let recommendSection =
    HorizontalGridScrollView(frame: .zero, repositoryDataType: RepositoryDataType.Recommend, gridType: GridType.rectangle)
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(mainScrollView)
        
        mainScrollView.addSubview(mainContainerView)
        view.addSubview(mainBottomInfoBar)
        setupBottomInfoBar()

        mainContainerView.addSubview(mainContentStackView)

        setupSubviews()
        extensionFunctions()
        
//        coloredForDebugging()
    }
    
    private func setupSubviews() {
        [bannerSliderView,
         subTitleView1, specialChipsSectionView,
         subTitleViewTodayPublished, todayPublishingView,
         subTitleViewHotSNS, hotSNSSection,
         subTitleViewGenre, genreSection,
         subTitleViewRecommend, recommendSection
        ].forEach { subTitleView in
            mainContentStackView.addArrangedSubview(subTitleView)
        }
        
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
        
        NSLayoutConstraint.activate([
            productInfoView.leadingAnchor.constraint(equalTo: mainBottomInfoBar.leadingAnchor),
            productInfoView.trailingAnchor.constraint(equalTo: mainBottomInfoBar.trailingAnchor),
            productInfoView.bottomAnchor.constraint(equalTo: mainBottomInfoBar.bottomAnchor),
            productInfoView.heightAnchor.constraint(equalToConstant: 60)

        ])
        
    }
    
   private func coloredForDebugging() {
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
}
