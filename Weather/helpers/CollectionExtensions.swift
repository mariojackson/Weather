//
//  CollectionExtensions.swift
//  Weather
//
//  Created by Mario Jackson on 3/26/23.
//

import Foundation


extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
