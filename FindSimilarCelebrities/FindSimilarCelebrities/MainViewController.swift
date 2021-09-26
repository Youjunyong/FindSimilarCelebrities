//
//  ViewController.swift
//  FindSimilarCelebrities
//
//  Created by 유준용 on 2021/09/18.
//

import UIKit
import CBFlashyTabBarController

class MainViewController: UIViewController{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    
    


    let picker = UIImagePickerController()
    func openLibrary(){
      picker.sourceType = .photoLibrary
      present(picker, animated: false, completion: nil)
    }

    func openCamera(){
      picker.sourceType = .camera
      present(picker, animated: false, completion: nil)
    }

    @IBAction func addAction(_ sender: Any) {
    
    let alert =  UIAlertController(title: "원하는 타이틀", message: "원하는 메세지", preferredStyle: .actionSheet)
    let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
    }
    let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
    self.openCamera()
    }

    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alert.addAction(library)
    alert.addAction(camera)
    alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
    }



    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        picker.delegate = self
        
        
        
    }
}

extension MainViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            let fileUrl = info[.imageURL] as? URL
            let strURL = fileUrl!.absoluteString
            imageView.image = image
            uploadImage(paramName: "image", fileName: "image", image: image , to: "face")
        }
        dismiss(animated: true, completion: nil)
    }


}




