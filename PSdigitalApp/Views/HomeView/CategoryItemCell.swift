//
//  CategoryItemCell.swift
//  PSdigitalApp
//
//  Created by Bassam on 7/2/22.
//

import UIKit

class CategoryItemCell: UICollectionViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var details: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var customizeBtn: UIButton!
    
    var ItemCellData: CategoryItemsResult!{
        didSet{
            name.text = ItemCellData.name
            details.text = ItemCellData.resultDescription
            if ItemCellData.imagePath != nil{
                imageView.sd_setImage(with: URL(string: ItemCellData.imagePath?.replacingOccurrences(of: " ", with: "%20") ?? ""), completed: nil)
            }
        }
    }
}
