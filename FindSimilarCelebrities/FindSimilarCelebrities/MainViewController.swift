//
//  ViewController.swift
//  FindSimilarCelebrities
//
//  Created by 유준용 on 2021/09/18.
//

import UIKit

class MainViewController: UIViewController{
    
    
    
//    struct Networking {
//        var urlSession = URLSession.shared
//
//        func sendPostRequest(
//            to url: URL,
//            body: Data,
//            then handler: @escaping (Result<Data, Error>) -> Void
//        ) {
//            var request = URLRequest(
//                url: url,
//                cachePolicy: .reloadIgnoringLocalCacheData
//            )
//
//            request.httpMethod = "POST"
//
//            let task = urlSession.uploadTask(
//        with: request,
//        from: body,
//        completionHandler: { data, response, error in
//            // Validate response and call handler
//            print("1",data)
//            print("2",response)
//            print("3",error)
//        }
//    )
//
//            task.resume()
//        }
//    }
    
    
    
    
    var file: URL?

    @IBOutlet weak var imageView: UIImageView!
    
    

    func convertFormField(named name: String,
                                  value: String,
                                  using boundary: String) -> String {
        let mimeType = "<Content-Type header here>"
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "Content-Type: \(mimeType)\r\n\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        
        return fieldString
    }

    func requestGet(query : UIImage){
        
//        let file = query.pngData()
        

        let httpBody = NSMutableData()
        let boundary = "Boundary-\(UUID().uuidString)"
//        imageView.image = query
        let fileData = query.jpegData(compressionQuality: 0.5)! as Data
        
        
        httpBody.appendString(convertFormField(named: "image", value: "image", using: boundary))
        

        httpBody.append(convertFileData(fieldName: "image",
                                        fileName: "image",
                                        mimeType: "multipart/form-data",
                                        fileData: fileData,
                                        using: boundary))

        httpBody.appendString("--\(boundary)--")

        
        let clientID = "s9djJV1HxQ0PZJDEz_xH"
        let clientSecret = "K5rhsSCZfo"
        let strURL : String = "https://openapi.naver.com/v1/vision/celebrity"
        let apiURL = URL(string: strURL)
        var request = URLRequest(url: apiURL!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")

        request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
//        request.httpBody = httpBody as Data
        

        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let data = data else {return}
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]

            print("<1>",json)
//            print("<2>",response)
//            print("<3>",error)

        }.resume()
        
    }
    
    
//    func requestIdentify() {
//        guard let sendData = imgObservable.value else {
//        return
//      }
//        let boundary = generateBoundaryString()
//        let body: [String: String] = ["userName": userName]
//        let bodyData = createBody(parameters: body,
//                                boundary: boundary,
//                                data: sendData,
//                                mimeType: "image/jpg",
//                                filename: "identifyImage.jpg")
//        service.requestIdentifys(boundary: boundary, bodyData: bodyData) { response in
//            switch response {
//          case .success(let statusCode):
//              print(statusCode)
//          case .failed(let err):
//              print(err)
//            }
//            }
//        }
//
//      private func generateBoundaryString() -> String {
//            return "Boundary-\(UUID().uuidString)"
//      }
//        private func createBody(parameters: [String: String]
//                              , boundary: String, data: Data,
//                              mimeType: String,
//                              filename: String) -> Data {
//        var body = Data()
//        let imgDataKey = "img"
//        let boundaryPrefix = "--\(boundary)\r\n"
//        for (key, value) in parameters {
//            body.append(boundaryPrefix.data(using: .utf8)!)
//            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
//            body.append("\(value)\r\n".data(using: .utf8)!) }
//            body.append(boundaryPrefix.data(using: .utf8)!)
//            body.append("Content-Disposition: form-data; name=\"\(imgDataKey)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
//            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
//            body.append(data)
//            body.append("\r\n".data(using: .utf8)!)
//            body.append("--".appending(boundary.appending("--")).data(using: .utf8)!)
//            return body as Data
//      }

    
    
    
    
    
    
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
//            imageView.image = image
//            print(info)
//            UIImagePickerController.InfoKey.imageURL
//            print("@@@")
            

//            requestGet(query : image)
            //          let fileData = NSData(contentsOfFile:paramSrc, options:[]) as Data

            
//            let resizedImage = resizeImage(image: image, newWidth: 300)
//            let jpegimage = image.jpegData(compressionQuality: 0.5)!
            let fileUrl = info[.imageURL] as? URL
            
//            print(fileUrl?.absoluteString)
            let strURL = fileUrl!.absoluteString
            
            let nsURL = NSURL(string: strURL)
            
//            let convertURL = URL(fileURLWithPath: strURL)
            

//            let imageData = try! Data(contentsOf: convertURL)
            let nsData = NSData(contentsOf: nsURL! as URL)
            imageView.image =  UIImage(data: nsData as! Data)
            
            
            
            
            let pngData = image.pngData()!
            uploadImage(paramName: "image", fileName: "image", image: image)
//            network(file: pngData)
//            print(String(data: pngData, encoding: .utf8) )
//            let img = try! NSData(contentsOf: url as! URL, options: []) as Data
            
//            let data = NSData(contentsOfURL: url!)
            
//            let fileContent = String(data: nsData, encoding: .utf8)
//            print(try! String(contentsOfFile: strURL, encoding: .utf8))
//                network()
//            network(file: nsData)
//            print(String(data: jpegimage, encoding: .utf8))
            
        }
        dismiss(animated: true, completion: nil)
    }


}




