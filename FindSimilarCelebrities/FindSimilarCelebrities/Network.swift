import UIKit
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

func uploadImage(paramName: String, fileName: String, image: UIImage) {
    let url = URL(string: "https://openapi.naver.com/v1/vision/celebrity")

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
            
            print(String(data: responseData!, encoding: .utf8)!)

            let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
            if let json = jsonData as? [String: Any] {
                
//                print("####")
//                print(json)
            }
        }
    }).resume()
}



