//
//  Cell.swift
//  Balina
//
//  Created by luqrri on 23.08.22.
//

import UIKit

class Cell: UICollectionViewCell{

    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image
    }

    func setupCell(product: Product) {
        image.image = product.image
    }

}
