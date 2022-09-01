//
//  ViewController.swift
//  Balina
//
//  Created by luqrri on 23.08.22.
//

import UIKit
import Foundation
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var imagePicker: UIImagePickerController!, contents: [Content?] = [Content?](), id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        downloadPhotos(url: URL(string: "https://junior.balinasoft.com/api/v2/photo/type")!)
        Thread.sleep(forTimeInterval: 2)
        self.collectionView.register(UINib(nibName: "Cell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    private func setup() {
        view.backgroundColor = .lightGray
        collectionView.backgroundColor = .lightGray
    }

    private func downloadPhotos(url: URL) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { print(error) }
            if let data = data, let welcome = try? JSONDecoder().decode(Welcome.self, from: data) {
               for i in welcome.content {
                    self.contents.append(i)
               }
            }
        }
        task.resume()
    }
    
}

//working with UICollectionView
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        let content = contents[indexPath.item]
        if let text = content?.image, let name = content?.name {
            cell.setupCell(text: text, name: name)
        }
        else if let name = content?.name {
            cell.setUpName(name: name)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        id = indexPath.item
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
}

//POST
extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate  {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        let imageData: Data = image.jpegData(compressionQuality: 0.1) ?? Data()
        imagePicker.dismiss(animated: true, completion: nil)
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Content-type": "multipart/form-data"
        ]
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append("Saley Ilya Igorevich".data(using: String.Encoding.utf8)!, withName: "name")
            multipartFormData.append(imageData, withName: "photo",fileName: "photo.png", mimeType: "image/png")
            multipartFormData.append("\(self.id)".data(using: String.Encoding.utf8)!, withName: "typeId")
            },
            to: URL(string: "https://junior.balinasoft.com/api/v2/photo")!, method: .post, headers: headers)
        { (result) in
            switch result {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print(response.result.value as Any)
                    }
                case .failure(let encodingError):
                    print(encodingError)
            }
        }
    }
}
