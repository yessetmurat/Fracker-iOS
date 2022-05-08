//
//  PadCellTappable.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import UIKit

protocol PadCellTappable where Self: UICollectionViewCell {

    func setTapState()
    func setNormalState()
}
