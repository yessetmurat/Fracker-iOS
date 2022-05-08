//
//  AnalyticsChartView.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import UIKit
import BaseKit

class AnalyticsChartView: UIView {

    private let contentView = UIView()
    private let stackView = UIStackView()
    private let titleStackView = UIStackView()
    private let minimumLabel = UILabel()
    private let averageLabel = UILabel()
    private let maximumLabel = UILabel()
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    private let selectorView = SelectorView()

    private var data: Chart?

    weak var delegate: AnalyticsChartViewDelegate?

    weak var selectorDelegate: SelectorViewDelegate? {
        didSet { selectorView.delegate = selectorDelegate }
    }

    var selectorTitles: [String] {
        get { selectorView.titles }
        set { selectorView.titles = newValue }
    }

    var selectorSelectedIndex: Int? {
        get { selectorView.selectedIndex }
        set { selectorView.selectedIndex = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setLayoutConstraints()
        stylize()
        setActions()
    }

    private func addSubviews() {
        addSubview(contentView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleStackView)
        titleStackView.addArrangedSubview(maximumLabel)
        titleStackView.addArrangedSubview(averageLabel)
        titleStackView.addArrangedSubview(minimumLabel)
        stackView.addArrangedSubview(collectionView)
        addSubview(selectorView)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        contentView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            contentView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24),
            contentView.rightAnchor.constraint(equalTo: rightAnchor, constant: -24),
            contentView.heightAnchor.constraint(equalToConstant: 180)
        ]

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += stackView.getLayoutConstraints(over: contentView, left: 16, top: 16, right: 0, bottom: 16)

        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [titleStackView.heightAnchor.constraint(equalToConstant: 120)]

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [collectionView.heightAnchor.constraint(equalToConstant: 148)]

        selectorView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            selectorView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16),
            selectorView.leftAnchor.constraint(equalTo: leftAnchor),
            selectorView.rightAnchor.constraint(equalTo: rightAnchor),
            selectorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            selectorView.heightAnchor.constraint(equalToConstant: 58)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        contentView.backgroundColor = BaseColor.lightGray
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true

        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .top

        titleStackView.axis = .vertical
        titleStackView.distribution = .equalCentering

        [minimumLabel, averageLabel, maximumLabel].forEach { label in
            label.font = BaseFont.semibold.withSize(12)
            label.textColor = BaseColor.gray
        }

        flowLayout.minimumInteritemSpacing = 12
        flowLayout.scrollDirection = .horizontal

        collectionView.backgroundColor = BaseColor.lightGray
        collectionView.contentInset.left = 4
        collectionView.contentInset.right = 16
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
    }

    private func setActions() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChartCell.self)
    }

    func set(data: Chart?) {
        self.data = data

        minimumLabel.text = data?.minimum
        averageLabel.text = data?.average
        maximumLabel.text = data?.maximum
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension AnalyticsChartView: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 16, height: 148)
    }
}

extension AnalyticsChartView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.analyticsChartView(self, didSelectItemIndex: indexPath.item)
    }
}

extension AnalyticsChartView: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return data?.items.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let item = data?.items[indexPath.item]
        let cell: ChartCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.title = item?.title
        cell.value = item?.value ?? 0
        return cell
    }
}

extension AnalyticsChartView: ResettableView {

    func reset() {
        data = nil
        delegate = nil
        minimumLabel.text = nil
        averageLabel.text = nil
        maximumLabel.text = nil
        selectorView.reset()
    }
}
