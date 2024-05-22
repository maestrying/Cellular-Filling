//
//  CellModel.swift
//  Cellular-Filling
//
//  Created by Дывак Максим on 22.05.2024.
//

import UIKit

enum CellType {
    case alive
    case dead
    case specialLive
}

struct CellModel {
    let title: String
    let type: CellType
    let description: String
    let image: UIImage
}
