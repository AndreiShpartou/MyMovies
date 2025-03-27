//
//  UIViewKeyboardScrollHandlingProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/03/2025.
//

import UIKit

protocol UIViewKeyboardScrollHandlingProtocol: UIView {
    func adjustScrollOffset(with offset: CGFloat)
    func adjustScrollInset(with inset: CGFloat)
}
