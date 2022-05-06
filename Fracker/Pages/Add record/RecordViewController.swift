//
//  RecordViewController.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import BaseKit

class RecordViewController: BaseViewController {

    var interactor: RecordInteractorInput?
    var router: RecordRouterInput?

    var viewToShake: UIView? { placeholderLabel.text == nil ? titleLabel : placeholderLabel }

    private let navigationView = BaseNavigationView()
    private let placeholderLabel = UILabel()
    private let titleLabel = UILabel()
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    private let keyboardView = KeyboardView()

    private lazy var titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: placeholderLabel.topAnchor)

    private var isCategoriesLoading = true {
        didSet { reloadWithAnimation() }
    }

    private var isCategoriesBeingRemoved = false {
        didSet { reloadWithAnimation() }
    }

    private var isAddingCategory = false {
        didSet { reloadWithAnimation() }
    }

    private var categories: [Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setLayoutConstraints()
        stylize()
        setActions()
    }

    private func addSubviews() {
        view.addSubview(navigationView)
        view.addSubview(placeholderLabel)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(keyboardView)
        view.bringSubviewToFront(titleLabel)
    }

    private func setLayoutConstraints() {
    	var layoutConstraints = [NSLayoutConstraint]()

        navigationView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            navigationView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationView.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]

        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            placeholderLabel.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
            placeholderLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            placeholderLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            placeholderLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor)
        ]

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabelTopConstraint,
            titleLabel.leftAnchor.constraint(equalTo: placeholderLabel.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: placeholderLabel.rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: placeholderLabel.bottomAnchor)
        ]

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: keyboardView.topAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 74)
        ]

        keyboardView.translatesAutoresizingMaskIntoConstraints = false
    	layoutConstraints += [
            keyboardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -56),
            keyboardView.widthAnchor.constraint(equalToConstant: 304),
            keyboardView.heightAnchor.constraint(equalToConstant: 280)
    	]

    	NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        view.backgroundColor = BaseColor.white

        navigationView.leftButtonIcon = .user
        navigationView.leftButtonInset = 16
        navigationView.rightButtonIcon = .barChart
        navigationView.rightButtonInset = 16

        placeholderLabel.text = "0"
        placeholderLabel.font = BaseFont.semibold.withSize(64)
        placeholderLabel.textAlignment = .center
        placeholderLabel.textColor = BaseColor.lightGray

        titleLabel.font = BaseFont.semibold.withSize(64)
        titleLabel.textAlignment = .center
        titleLabel.textColor = BaseColor.black
        titleLabel.isUserInteractionEnabled = true
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.2

        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0

        collectionView.contentInset.left = 20
        collectionView.contentInset.right = 14
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = BaseColor.white
    }

    private func setActions() {
        navigationView.leftButtonAction = { [weak self] in self?.interactor?.didTapOnLeftButton() }
        navigationView.rightButtonAction = { [weak self] in self?.router?.routeToAnalyticsPage() }

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryShimmerCell.self)
        collectionView.register(CategoryCell.self)
        collectionView.register(CategoryAddCell.self)
        collectionView.register(CategoryTextFieldCell.self)

        keyboardView.delegate = self

        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(longGestureRecognizerAction)
        )
        longPressGesture.minimumPressDuration = 0.5
        collectionView.addGestureRecognizer(longPressGesture)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        titleLabel.addGestureRecognizer(tapGesture)

        if let interactor = interactor {
            interactor.loadCategories()
        }
    }

    @objc private func longGestureRecognizerAction(_ gesture: UILongPressGestureRecognizer) {
        guard !isCategoriesLoading, !isAddingCategory, !isCategoriesBeingRemoved else { return }
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        isCategoriesBeingRemoved = true
    }

    @objc private func tapGestureAction() {
        view.endEditing(true)

        if isAddingCategory {
            isAddingCategory = false
        }

        if isCategoriesBeingRemoved {
            isCategoriesBeingRemoved = false
        }
    }
}

extension RecordViewController {

    private func reloadWithAnimation() {
        collectionView.performBatchUpdates { collectionView.reloadSections(IndexSet(integer: 0)) }
    }

    private func addPositionAnimation(for indexPath: IndexPath) {
        guard let attributes = collectionView.layoutAttributesForItem(at: indexPath) else { return }

        let convertedPoint = collectionView.convert(attributes.center, to: view.coordinateSpace)

        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.3
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = .init(name: CAMediaTimingFunctionName.easeIn)
        animation.fromValue = NSValue(cgPoint: titleLabel.center)
        animation.toValue = NSValue(cgPoint: convertedPoint)

        titleLabel.layer.add(animation, forKey: "titleLabelPosition")
    }

    private func addTitleLabelScaleAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.3
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = .init(name: CAMediaTimingFunctionName.easeIn)
        animation.fromValue = 1
        animation.toValue = 0

        titleLabel.layer.add(animation, forKey: "titleLabelScale")
    }

    private func addTitleLabelOpacityAnimation() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = 0.3
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = .init(name: CAMediaTimingFunctionName.easeIn)
        animation.fromValue = 1
        animation.toValue = 0

        titleLabel.layer.add(animation, forKey: "titleLabelOpacity")
    }
}

extension RecordViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let addCategory = isCategoriesLoading ? indexPath.item == 2 : indexPath.item == categories.count

        if addCategory && !isCategoriesBeingRemoved {
            return CGSize(width: isAddingCategory ? 164 : 62, height: 62)
        } else if isCategoriesLoading {
            return CGSize(width: 100, height: 62)
        }

        let titleWidth = categories[indexPath.item].description
            .size(withAttributes: [.font: BaseFont.semibold.withSize(14)])
            .width

        return CGSize(width: titleWidth + 38, height: 62)
    }
}

extension RecordViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == categories.count, !isAddingCategory {
            isAddingCategory = true
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            interactor?.didSelectCategory(at: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return !isCategoriesLoading && !isAddingCategory && !isCategoriesBeingRemoved
    }
}

extension RecordViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isCategoriesLoading ? 3 : isCategoriesBeingRemoved ? categories.count : categories.count + 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let addCategory = isCategoriesLoading ? indexPath.item == 2 : indexPath.item == categories.count

        if addCategory && !isCategoriesBeingRemoved {
            if isAddingCategory {
                let cell: CategoryTextFieldCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.delegate = self
                cell.startEditing()
                return cell
            } else {
                let cell: CategoryAddCell = collectionView.dequeueReusableCell(for: indexPath)
                return cell
            }
        } else if isCategoriesLoading {
            let cell: CategoryShimmerCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.view.startAnimating()
            return cell
        } else {
            let cell: CategoryCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.text = categories[indexPath.item].description
            cell.delegate = self
            cell.indexPath = indexPath
            cell.isRemoving = isCategoriesBeingRemoved
            return cell
        }
    }
}

extension RecordViewController: CategoryCellDelegate {

    func categoryCell(didTapOnRemoveAtIndexPath indexPath: IndexPath) {
        interactor?.removeCategory(at: indexPath)
    }
}

extension RecordViewController: CategoryTextFieldDelegate {

    func textFieldDidEndEditing(withEmoji emoji: String, text: String) {
        isAddingCategory = false

        if !text.isEmpty { interactor?.createCategory(withEmoji: emoji, name: text) }
    }
}

extension RecordViewController: KeyboardViewDelegate {

    func keyboardView(_ keyboardView: KeyboardView, didTapOnPadSymbol symbol: String) {
        interactor?.changeRecord(symbol: symbol)
    }
}

extension RecordViewController: RecordViewInput {

    func pass(isLoading: Bool) {
        self.isCategoriesLoading = isLoading
    }

    func pass(categories: [Category]) {
        self.categories = categories
    }

    func reloadCollectionView() {
        reloadWithAnimation()
    }

    func scrollToItem(at indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    func setRecord(result: NSAttributedString) {
        placeholderLabel.text = result.string.isEmpty ? "0" : nil
        titleLabel.attributedText = result
    }

    func deselectItem(at indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func moveAmountToCategory(at indexPath: IndexPath) {
        placeholderLabel.text = "0"

        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            guard let viewController = self else { return }
            viewController.titleLabel.attributedText = nil
            viewController.titleLabel.layer.removeAllAnimations()
            viewController.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            viewController.collectionView.deselectItem(at: indexPath, animated: true)
        }

        addPositionAnimation(for: indexPath)
        addTitleLabelScaleAnimation()
        addTitleLabelOpacityAnimation()
        CATransaction.commit()
    }

    func presentAuthorizationPage() {
        router?.presentAuthorizationPage()
    }
}
