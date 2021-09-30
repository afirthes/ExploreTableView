//
//  FontModel.swift
//  ExploreTableView
//
//  Created by Afir Thes on 29.09.2021.
//

import UIKit

struct FontModel {
    let name: String
    var isFavorite: Bool
}

class FontDataProvider {
    static var fonts: [FontModel] = {
        let fonts = UIFont.familyNames
        return fonts.map { name in
            return FontModel(name: name, isFavorite: false)
        }
    }()
}
