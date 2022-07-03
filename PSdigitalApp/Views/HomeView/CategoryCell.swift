//
//  CategoryCell.swift
//  PSdigitalApp
//
//  Created by Bassam on 7/1/22.
//

import UIKit


class CategoryCell: UICollectionViewCell {
    @IBOutlet var categoryImage: UIImageView!
    @IBOutlet var categoryName: UILabel!
    var categoryCellData: CategoryResult!{
        didSet{
            categoryImage.sd_setImage(with: URL(string: categoryCellData.imagePath ?? ""), completed: nil)
            categoryName.text = categoryCellData.name
        }
    }
}

