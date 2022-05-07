//
//  SelectorViewDelegate.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import Foundation

protocol SelectorViewDelegate: AnyObject {

    func selectorView(_ selectorView: SelectorView, didSelectItemAtIndex index: Int)
}
