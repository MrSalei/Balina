//
//  ViewController.swift
//  Balina
//
//  Created by luqrri on 23.08.22.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var imagePicker: UIImagePickerController!, contents: [Content?] = [Content?](), id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadPhotos(url: URL(string: "https://junior.balinasoft.com/api/v2/photo/type")!)
        Thread.sleep(forTimeInterval: 2)
        self.collectionView.register(UINib(nibName: "Cell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    private func downloadPhotos(url: URL) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { print(error) }
            if let data = data, let welcome = try? JSONDecoder().decode(Welcome.self, from: data) {
               for i in welcome.content {
                   if i.image != nil {
                       self.contents.append(i)
                   }
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
        let text = content!.image
        cell.setupCell(text: text!)
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
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}

//POST
extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate  {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let imageData: Data = image.jpegData(compressionQuality: 0.1) ?? Data()
        let imageStr: String = imageData.base64EncodedString()
        let parameters: [String:AnyHashable] = [
            "name":"Saley Ilya Igorevich",
            "photo":imageStr,
            "typeId":"\(id)"
        ]
        var postRequest = URLRequest(url: URL(string: "https://junior.balinasoft.com/api/v2/photo")!)
        postRequest.httpMethod = "POST"
        postRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        postRequest.httpBody = httpBody
        let task = URLSession.shared.dataTask(with: postRequest) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
}
