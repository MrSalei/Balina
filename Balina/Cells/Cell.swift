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
        self.image.image = nil
    }

    func setupCell(text: String) {
        downloadImage(from: URL(string: text)!)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            DispatchQueue.main.async {
                self.image.image = UIImage(data: data!)
            }
        }
    }

}
