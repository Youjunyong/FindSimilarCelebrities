import UIKit
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
//{
//    "info": {
//        "size": {
//            "width": 340,
//            "height": 225
//        },
//        "faceCount": 1
//    },
//    "faces": [
//        {
//            "celebrity": {
//                "value": "하정우",
//                "confidence": 0.571838
//            }
//        }
//    ]
//}

struct Root: Codable{
    var info: String
    var faces: Array<String>
}

func uploadImage(paramName: String, fileName: String, image: UIImage) {
    let url = URL(string: "https://openapi.naver.com/v1/vision/celebrity")
//    celebrity

    // 바운더리를 구분하기 위한 임의의 문자열. 각 필드는 `--바운더리`의 라인으로 구분된다.
    let boundary = UUID().uuidString
    let session = URLSession.shared

    // URLRequest 생성하기
    var urlRequest = URLRequest(url: url!)
    urlRequest.httpMethod = "POST"
    urlRequest.addValue("s9djJV1HxQ0PZJDEz_xH", forHTTPHeaderField: "X-Naver-Client-Id")
    urlRequest.addValue("K5rhsSCZfo", forHTTPHeaderField: "X-Naver-Client-Secret")
    // Boundary랑 Content-type 지정해주기.
    urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    var data = Data()

    // --(boundary)로 시작.
    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
    // 헤더 정의 - 문자열로 작성 후 UTF8로 인코딩해서 Data타입으로 변환해야 함
    data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
    // 헤더 정의 2 - 문자열로 작성 후 UTF8로 인코딩해서 Data타입으로 변환해야 함, 구분은 \r\n으로 통일.
    data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
    // 내용 붙이기
    data.append(image.pngData()!)

    // 모든 내용 끝나는 곳에 --(boundary)--로 표시해준다.
    data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
    // Send a POST request to the URL, with the data we created earlier
    
    session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
        if error == nil {
                
            let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: []) as! NSDictionary
            if let info = jsonData!["info"] as? NSDictionary {
                print(info)
            }
            
            let faces = jsonData!["faces"] as? NSArray
            if let face = faces![0] as? NSDictionary {
                if let value = face["celebrity"] as? NSDictionary {
                    print(value["value"])
                }
                
                    
                
            }

            

//            if let json = jsonData as? [String:Any] {
//                if let new = json["faces"] as? Data{
//
//                    print(String(data: new, encoding: .utf8))
//                }
////                print("##\(new?[0])##" )
////                let a = "\(new?[0])".data(using: .utf8)
//
//
//
//
////                print(type(of: json["faces"]))
//            }
            
            

        }
    }).resume()
}


//https://www.it-gundan.com/ko/ios/swift%EC%97%90%EC%84%9C-json-%EB%B0%B0%EC%97%B4%EC%9D%84-%EB%B0%B0%EC%97%B4%EB%A1%9C-%EA%B5%AC%EB%AC%B8-%EB%B6%84%EC%84%9D%ED%95%98%EB%8A%94-%EB%B0%A9%EB%B2%95/830328697/amp/
 
