//
//  KeyboardView.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import UIKit
import Base

protocol KeyboardViewDelegate: AnyObject {

    func keyboardView(_ keyboardView: KeyboardView, didTapOnPadSymbol symbol: String)
}

class KeyboardView: UIView {

    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

    weak var delegate: KeyboardViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(collectionView)
        collectionView.layout(over: self)
        stylize()
        setActions()
    }

    private func stylize() {
        flowLayout.itemSize = CGSize(width: 96, height: 64)
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8

        collectionView.backgroundColor = BaseColor.white
    }

    private func setActions() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PadCell.self)
    }

    private func getDigitImage(from text: String) -> UIImage {
        let font = BaseFont.semibold.withSize(32)
        let imageSize = CGSize(width: 72, height: 72)

        return text.image(with: imageSize, font: font)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension KeyboardView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PadCellTappable else { return false }

        cell.setTapState()

        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()

        return true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let string = String((indexPath.item + 1) % 11)
        var symbol = string

        switch indexPath.item {
        case 9: symbol = "."
        case 11: symbol = "delete"
        default: break
        }

        delegate?.keyboardView(self, didTapOnPadSymbol: symbol)
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PadCellTappable else { return }

        UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction]) {
            cell.setNormalState()
        }
    }
}

extension KeyboardView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 12 }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: PadCell = collectionView.dequeueReusableCell(for: indexPath)
        let string = String((indexPath.item + 1) % 11)
        switch indexPath.item {
        case 9: cell.image = getDigitImage(from: ".")
        case 11: cell.image = BaseImage.delete.templateImage
        default: cell.image = getDigitImage(from: string)
        }
        return cell
    }
}
