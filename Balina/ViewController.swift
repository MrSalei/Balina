//
//  ViewController.swift
//  Balina
//
//  Created by luqrri on 23.08.22.
//

import UIKit

struct ToSend {
    var id: Int, fio: String, photo: UIImage
}

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func buttonPressed(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        toSend = ToSend(id: <#T##Int#>, fio: "Saley Ilya Igorevich", photo: image)
    }
    
    var imagePicker: UIImagePickerController!, toSend: ToSend!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadPhotos(url: URL(string: "https://junior.balinasoft.com/swagger-ui.html?urls.primaryName=api2#/Photos")!)
        collectionView.register(UINib(nibName: "Cell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func downloadPhotos(url: URL) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { print(error) }
            if let data = data {
                print(String(decoding: data, as: UTF8.self))
            }
            //if let data = data, let joke = try? JSONDecoder().decode(Welcome.self, from: data) {
            //   print(joke.setup!)
            //  }
        }
        task.resume()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
        let product = menu.products[indexPath.item]
        cell.setupCell(product: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
