//
//  ViewController.swift
//  Project10
//
//  Created by Luca Hummel on 03/08/21.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        // Do any additional setup after loading the view.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCollectionViewCell else { fatalError("enable to dequeue a PersonCollectionViewCell") }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Edit or delete?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive) {
            [weak self] _ in
            self?.people.remove(at: indexPath.row)
            collectionView.reloadData()
        })
        
        ac.addAction(UIAlertAction(title: "Edit", style: .default){
            [weak self] _ in
            let ac1 = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            ac1.addTextField()
            
            ac1.addAction(UIAlertAction(title: "OK", style: .default) {
                [weak self, weak ac1] _ in
                guard let newName = ac1?.textFields?[0].text else {return}
                person.name = newName
                self?.collectionView.reloadData()
            })
            
            ac1.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self?.present(ac1, animated: true)
        })
        
        present(ac, animated: true)
        
        
    }
    
    @objc func addNewPerson() {
        let ac = UIAlertController(title: "Camera ou Library?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: addNewPersonImageCamera))
        ac.addAction(UIAlertAction(title: "Libary", style: .default, handler: addNewPersonImageLibrary))
        present(ac, animated: true)
    }
    
    @objc func addNewPersonImageCamera(action: UIAlertAction) {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        } else {
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        }
    }
    
    @objc func addNewPersonImageLibrary(action: UIAlertAction) {
        let picker = UIImagePickerController()
        
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknow", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

