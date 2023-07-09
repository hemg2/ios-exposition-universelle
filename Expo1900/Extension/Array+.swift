//
//  Array+.swift
//  Expo1900
//
//  Created by Hemg, RedMango on 2023/07/09.
//

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
