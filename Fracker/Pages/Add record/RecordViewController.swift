//
//  RecordViewController.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Base

class RecordViewController: BaseViewController {

    var interactor: RecordInteractorInput?
    var router: RecordRouterInput?

    private let titleLabel = UILabel()
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    private let keyboardView = KeyboardView()

    override func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        navigationController.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setLayoutConstraints()
        stylize()
        setActions()
    }

    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(keyboardView)
    }

    private func setLayoutConstraints() {
    	var layoutConstraints = [NSLayoutConstraint]()

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor)
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

        titleLabel.text = "2 000₸"
        titleLabel.font = BaseFont.semibold.withSize(64)
        titleLabel.textAlignment = .center
        titleLabel.textColor = BaseColor.black

        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 8

        collectionView.contentInset.left = 24
        collectionView.contentInset.right = 24
        collectionView.alwaysBounceHorizontal = true

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: BaseImage.user.uiImage,
            style: .plain,
            target: self,
            action: #selector(leftBarButtonItemAction)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: BaseImage.barChart.uiImage,
            style: .plain,
            target: self,
            action: #selector(rightBarButtonItemAction)
        )
    }

    private func setActions() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCell.self)
        collectionView.register(AddCategoryCell.self)
    }

    @objc private func leftBarButtonItemAction() {
        router?.presentAuthPage()
    }

    @objc private func rightBarButtonItemAction() {

    }
}

extension RecordViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
//        let titleWidth = filterTypes[indexPath.row].title
//            .size(withAttributes: [.font: BaseFont.semibold.withSize(14)])
//            .width
//        return isLoading ? CGSize(width: 120, height: 53) : CGSize(width: titleWidth + 32, height: 53)
        return indexPath.item == 2 ? CGSize(width: 48, height: 42) : CGSize(width: 120, height: 42)
    }
}

extension RecordViewController: UICollectionViewDelegate {

}

extension RecordViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.item == 2 {
            let cell: AddCategoryCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        }

        let cell: CategoryCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
}

extension RecordViewController: RecordViewInput {

}
