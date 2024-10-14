//
//  ChipsSectionView.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/8/24.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class ChipsSectionView: UIView, View {

    typealias Reactor = ChipsSelectionReactor
    var disposeBag = DisposeBag()

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()

        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceHorizontal = true
        sv.alwaysBounceVertical = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let verticalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        sv.distribution = .fill
        sv.spacing = 4
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let horizontalStackView1: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .equalSpacing
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let horizontalStackView2: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .equalSpacing
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let chipTapSubject = PublishSubject<(Int, ChipData)>()

    var chipTapped: Observable<(Int, ChipData)> {
        return chipTapSubject.asObservable()
    }

    override init(frame: CGRect) {

        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
        setupConstraints()
        setupReactor(repository: PointListRepositoryImpl())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(horizontalStackView1)
        verticalStackView.addArrangedSubview(horizontalStackView2)
    }

    private func setupChips(chipList: [ChipData]) {

        horizontalStackView1.arrangedSubviews.forEach { $0.removeFromSuperview() }
        horizontalStackView2.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let (firstHalf, secondHalf) = chipList.splitByNameCharacterCount()

        makeChipListUi(chipList: firstHalf, addStartIdx: 0, containerView: horizontalStackView1)
        makeChipListUi(chipList: secondHalf, addStartIdx: firstHalf.count, containerView: horizontalStackView2)

        layoutIfNeeded()
    }

    private func makeChipListUi(chipList: [ChipData], addStartIdx: Int, containerView: UIStackView) {
        for (index, data) in chipList.enumerated() {
            let chip = ChipView(index: addStartIdx + index, data: data, backgroundColor: .systemGray4)
            containerView.addArrangedSubview(chip)

            chip.tapObservable
                .subscribe(onNext: { [weak self] (idx, data) in
                    self?.chipTapped(index: idx, data: data)
                })
                .disposed(by: disposeBag)
        }
    }

    private func chipTapped(index: Int, data: ChipData) {

        chipTapSubject.onNext((index, data))
    }

    private func setupReactor(repository: PointListRepositoryImpl) {
       self.reactor = ChipsSelectionReactor(PointListRepository: repository)
       self.reactor?.action.onNext(.fetchDataList)
   }

   func bind(reactor: Reactor) {

       reactor.state.map { $0.datas }
           .distinctUntilChanged()
           .bind { [weak self] datas in
               self?.setupItems(datas)
           }
           .disposed(by: disposeBag)

   }

    func setupItems(_ datas: [ChipData]) {
        guard datas.count > 0 else { return }
        setupChips(chipList: datas)
    }

}

extension ChipsSectionView {
    private func setupConstraints() {
        scrollView.pinToEdges(of: self)
        contentView.pinToEdges(of: scrollView)

        contentView.widthAnchor.constraint(greaterThanOrEqualTo: scrollView.widthAnchor).isActive = true

        verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
    }
}
