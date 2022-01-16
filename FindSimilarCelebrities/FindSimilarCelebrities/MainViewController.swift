//
//  ViewController.swift
//  FindSimilarCelebrities
//
//  Created by 유준용 on 2021/09/18.
//

import UIKit
import CBFlashyTabBarController

class MainViewController: UIViewController{
    lazy var datamanager = APIDatamanager()
    
    @IBOutlet weak var imageView: UIImageView!
    var dataDict : [String:String] = [:]
    let picker = UIImagePickerController()
    @IBAction func openLibrary(){
      picker.sourceType = .photoLibrary
      present(picker, animated: false, completion: nil)
    }

    @IBAction func openCamera(){
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
        picker.delegate = self
        DataManager.shared.fetchRecord()
    }
}

extension MainViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let boundary = UUID().uuidString
        let semaphore = DispatchSemaphore(value: 0)
        guard let image = info[.originalImage] as? UIImage else{return}
        let pngImage = image.pngData()!
        let session = URLSession.shared
        var urlRequest = datamanager.encodeUrl(to: "celebrity", boundary: boundary)
        var data = datamanager.encodeData(image: image, boundary:boundary)
        
        session.uploadTask(with: urlRequest, from: data, completionHandler: { [self] responseData, response, error in
            if error == nil {
                datamanager.parseCelebrity(responseData: responseData!, img: pngImage)
            }
            semaphore.signal()
        }).resume()
        semaphore.wait()
        urlRequest = datamanager.encodeUrl(to: "face", boundary: boundary)
        data = datamanager.encodeData(image: image, boundary:boundary)
        session.uploadTask(with: urlRequest, from: data, completionHandler: { [self] responseData, response, error in
            if error == nil {
                let dataDict = datamanager.parseFace(responseData: responseData!, img: pngImage)
                DataManager.shared.addNewRecord(dataDict, pngImage)
            }
            semaphore.signal()
        }).resume()
        semaphore.wait()
        DataManager.shared.fetchRecord()
        dismiss(animated: true, completion: nil)
        guard let DetailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {return}
        DetailVC.dataIdx = 0
        self.present(DetailVC, animated: true, completion: nil)
    }


}




