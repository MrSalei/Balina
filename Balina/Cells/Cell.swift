//
//  Cell.swift
//  Balina
//
//  Created by luqrri on 23.08.22.
//

import UIKit

class Cell: UICollectionViewCell{

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.image.image = nil
    }
    
    func setUpName(name: String) {
        nameLabel.text = name
    }

    func setupCell(text: String, name: String) {
        downloadImage(from: URL(string: text)!)
        nameLabel.text = name
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
