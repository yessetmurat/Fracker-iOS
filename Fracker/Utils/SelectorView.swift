//
//  SelectorView.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import UIKit
import BaseKit

class SelectorView: UIView {

    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

    var titles: [String] = []

    var selectedIndex: Int? {
        didSet {
            guard let selectedIndex = selectedIndex else { return }

            collectionView.selectItem(
                at: IndexPath(item: selectedIndex, section: 0), animated: false, scrollPosition: .left
            )
        }
    }

    weak var delegate: SelectorViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(collectionView)
        collectionView.layout(over: self)
        stylize()
        setActions()
    }

    private func stylize() {
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.scrollDirection = .horizontal

        collectionView.backgroundColor = .clear
        collectionView.contentInset.left = 24
        collectionView.contentInset.right = 24
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }

    private func setActions() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SelectorCell.self)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension SelectorView: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let titleWidth = titles[indexPath.item]
            .size(withAttributes: [.font: BaseFont.semibold])
            .width

        return CGSize(width: titleWidth + 20, height: 42)
    }
}

extension SelectorView: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        selectedIndex = indexPath.item
        delegate?.selectorView(self, didSelectItemAtIndex: indexPath.item)
    }
}

extension SelectorView: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return titles.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: SelectorCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.title = titles[indexPath.item]
        return cell
    }
}

extension SelectorView: ResettableView {

    func reset() {
        titles = []
        selectedIndex = nil
        delegate = nil
    }
}
