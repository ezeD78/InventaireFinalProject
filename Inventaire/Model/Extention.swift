//
//  Extention.swift
//  Inventaire
//
//  Created by Ezequiel Gomes on 25/03/2024.
//

import Foundation
import VisionKit
import SwiftUI
import SwiftData

extension RecognizedItem: Equatable {
    public static func == (lhs: RecognizedItem, rhs: RecognizedItem) -> Bool {
        lhs.id ==  rhs.id
    }

}
extension Color {
    func getdictonnariesColor() -> [String: Double] {

        let red = self.resolve(in: EnvironmentValues()).red
        let blue = self.resolve(in: EnvironmentValues()).blue
        let green = self.resolve(in: EnvironmentValues()).green
        return ["red": Double(red), "blue": Double(blue), "green": Double(green)]
    }

}
