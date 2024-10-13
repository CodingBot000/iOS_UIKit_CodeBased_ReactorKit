//
//  ImageSliderView.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/7/24.
//



import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class ImageSliderView: UIView, View {
   
    typealias Reactor = ImageSliderReactor
    var disposeBag = DisposeBag()
    
    private var baseSliderDatas: [ProductData] = []
    private var internalSliderDatas: [ProductData] = []
    
    private var collectionView: UICollectionView!
    private var timer: Timer?
    private var currentIndex: Int = 1
    
    private var isManualScrolling: Bool = false
    private var isAutoScrolling: Bool = false
  
    private var isAdjustingOffset = false
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .black
        pc.pageIndicatorTintColor = .lightGray
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    private let selectedSliderDataSubject = PublishSubject<(ProductData, Int)>()
    
    var selectedSliderData: Observable<(ProductData, Int)> {
        return selectedSliderDataSubject.asObservable()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupCollectionView()
        setupPageControl()
        setupConstraints()
        setupReactor()
        startTimer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer?.invalidate()
    }
 
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = self.bounds.size
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
      
        collectionView.register(ImageSliderCell.self, forCellWithReuseIdentifier: ImageSliderCell.identifier)
        

        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupPageControl() {
        self.addSubview(pageControl)
    }
    
    private func setupConstraints() {
  
        NSLayoutConstraint.activate([
       
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -10),
            
            pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.autoScroll()
        }
    }
    
    private func resetTimer() {
        timer?.invalidate()
        startTimer()
    }
    
    @objc private func autoScroll() {
        guard internalSliderDatas.count > 1 else { return }
        if isAdjustingOffset { return }
        isAutoScrolling = true
        currentIndex += 1
        scrollToCurrentIndex(animated: true)
    }
    
    private func scrollToCurrentIndex(animated: Bool) {
        guard currentIndex >= 0 && currentIndex < internalSliderDatas.count else { return }
        collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: animated)
    }
 
    private func setupReactor() {
        let repository = BannersRepositoryImpl()
        self.reactor = ImageSliderReactor(bannersRepository: repository)
        self.reactor?.action.onNext(.fetchImages)
    }

    func bind(reactor: Reactor) {

        reactor.state.map { $0.productDatas }
            .distinctUntilChanged()
            .bind { [weak self] productDatas in
                self?.setProductDatas(productDatas)
            }
            .disposed(by: disposeBag)
      
        reactor.state.map { $0.currentIndex }
            .distinctUntilChanged()
            .bind { [weak self] index in
                self?.setCurrentIndex(index)
            }
            .disposed(by: disposeBag)
    }
  
    func setProductDatas(_ datas: [ProductData]) {
        guard datas.count > 0 else { return }
        
        baseSliderDatas = datas
        internalSliderDatas = [datas.last!] + datas + [datas.first!]
        currentIndex = 1
        pageControl.numberOfPages = baseSliderDatas.count
        pageControl.currentPage = 0
        collectionView.reloadData()
        
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .left, animated: false)
        }
    }

    func setCurrentIndex(_ index: Int) {
        guard index < baseSliderDatas.count else { return }
        currentIndex = index + 1
        pageControl.currentPage = index
        collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: false)
    }
}


extension ImageSliderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return internalSliderDatas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSliderCell.identifier, for: indexPath) as? ImageSliderCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: internalSliderDatas[indexPath.item])
        return cell
    }
}


extension ImageSliderView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
                        indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

extension ImageSliderView: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 수동으로 스크롤시 타이머, 자동스크롤링  일시정지
        isManualScrolling = true
        timer?.invalidate()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isManualScrolling = false
            resetTimer()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        handleScroll()
        isManualScrolling = false
        resetTimer()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        handleScroll()
        isAutoScrolling = false
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
        let originalIndex = indexPath.item - 1
        guard originalIndex >= 0 && originalIndex < baseSliderDatas.count else { return }
        let selectedImage = baseSliderDatas[originalIndex]
        
        selectedSliderDataSubject.onNext((selectedImage, originalIndex))
    }
    
    private func handleScroll() {
        let pageWidth = collectionView.frame.size.width
        guard pageWidth > 0 else { return }
        currentIndex = Int(collectionView.contentOffset.x / pageWidth)
        
        if currentIndex == 0 {
  
            isAdjustingOffset = true
            currentIndex = internalSliderDatas.count - 2
            collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: false)
            isAdjustingOffset = false
        } else if currentIndex == internalSliderDatas.count - 1 {

            isAdjustingOffset = true
            currentIndex = 1
            collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: false)
            isAdjustingOffset = false
        }
        
       
        if currentIndex >= 1 && currentIndex <= baseSliderDatas.count {
            pageControl.currentPage = currentIndex - 1
        }
    }
}
