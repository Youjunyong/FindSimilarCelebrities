import UIKit
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: - Face json
//{
//    "info": {
//        "size": {
//            "width": 620,
//            "height": 765
//        },
//        "faceCount": 1
//    },
//    "faces": [
//        {
//            "roi": {
//                "x": 212,
//                "y": 174,
//                "width": 249,
//                "height": 249
//            },
//            "landmark": {
//                "leftEye": {
//                    "x": 282,
//                    "y": 243
//                },
//                "rightEye": {
//                    "x": 390,
//                    "y": 236
//                },
//                "nose": {
//                    "x": 346,
//                    "y": 303
//                },
//                "leftMouth": {
//                    "x": 304,
//                    "y": 373
//                },
//                "rightMouth": {
//                    "x": 386,
//                    "y": 368
//                }
//            },
//            "gender": {
//                "value": "male",
//                "confidence": 1.0
//            },
//            "age": {
//                "value": "35~39",
//                "confidence": 1.0
//            },
//            "emotion": {
//                "value": "neutral",
//                "confidence": 0.999968
//            },
//            "pose": {
//                "value": "frontal_face",
//                "confidence": 0.999339
//            }
//        }
//    ]
//}

// MARK: Celebrity json
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
var retDict : [String:String] = [:]
func parseFace(responseData: Data, img: Data)->[String:String]{

    if let jsonData = try? JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary {
        if let info = jsonData["info"] as? NSDictionary {
            retDict["faceCount"] = "\(String(describing: info["faceCount"]))"
        }
        if let faces = jsonData["faces"] as? NSArray{
            if faces.count > 0, let face = faces[0] as? NSDictionary{
                if let gender = face["gender"] as? NSDictionary{
                    
                    let value = gender["value"]  as! String
                    let confidence = gender["confidence"] as! Double
                    retDict["genderValue"] = value
                    retDict["genderConfidence"] = "\(round(confidence * 10000)/100)%"
                }
                if let emotion = face["emotion"] as? NSDictionary{
                    
                    let value = emotion["value"]  as! String
                    let confidence = emotion["confidence"] as! Double
                    retDict["emotionValue"] = value
                    retDict["emotionConfidence"] = "\(round(confidence * 10000)/100)%"
                }
    //            emotion
                if let age = face["age"] as? NSDictionary{
                    
                    let value = age["value"]  as! String
                    let confidence = age["confidence"] as! Double
                    retDict["ageValue"] = value
                    retDict["ageConfidence"] = "\(round(confidence * 10000)/100)%"
                }
    //            age
                if let pose = face["pose"] as? NSDictionary{
                    
                    let value = pose["value"]  as! String
                    let confidence = pose["confidence"] as! Double
                    retDict["poseValue"] = value
                    retDict["poseConfidence"] = "\(round(confidence * 10000)/100)%"
                }
    //            pose
            }
            print(#function)
            
        }else{
            // 잘못된 사진 예외처리
        }
        
        
    }
    return retDict

}
func parseCelebrity(responseData: Data, img: Data){
    if let jsonData = try? JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary {
        if let info = jsonData["info"] as? NSDictionary {
            retDict["faceCount"] = "\(String(describing: info["faceCount"]))"
        }
        if let faces = jsonData["faces"] as? NSArray{
            if faces.count > 0, let face = faces[0] as? NSDictionary {
                if let celebrity = face["celebrity"] as? NSDictionary {
                    let value = celebrity["value"] as! String
                    let confidence = celebrity["confidence"] as! Double
                    retDict["celebrityValue"] = value
                    retDict["celebrityConfidence"] = "\(round(confidence * 10000)/100)%"
                }
            }
        }
        
    }
}

func encodeData(image: UIImage, boundary: String)-> Data{
    
    var data = Data()
    let pngImage = image.pngData()!
//    let boundary = UUID().uuidString
    let paramName = "image"
    let fileName = "image"
    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
    data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
//    data.append("Content-Disposition: form-data; name=\"image\"; filename=\"image\"\r\n".data(using: .utf8)!)
    data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
    data.append(pngImage)
    data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
    return data
}

func encodeUrl(to: String, boundary: String )-> URLRequest{
    let url = URL(string: "https://openapi.naver.com/v1/vision/\(to)")
//    let boundary = UUID().uuidString
    var urlRequest = URLRequest(url: url!)
    urlRequest.httpMethod = "POST"
    urlRequest.addValue("s9djJV1HxQ0PZJDEz_xH", forHTTPHeaderField: "X-Naver-Client-Id")
    urlRequest.addValue("K5rhsSCZfo", forHTTPHeaderField: "X-Naver-Client-Secret")
    urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    return urlRequest
}

//func uploadImage(paramName: String, fileName: String, image: UIImage, to: String)->{
    // to : face or celebrity

//    let url = URL(string: "https://openapi.naver.com/v1/vision/\(to)")
//    let boundary = UUID().uuidString
//    let session = URLSession.shared
//    let pngImage = image.pngData()!
//    var urlRequest = URLRequest(url: url!)
//    urlRequest.httpMethod = "POST"
//    urlRequest.addValue("s9djJV1HxQ0PZJDEz_xH", forHTTPHeaderField: "X-Naver-Client-Id")
//    urlRequest.addValue("K5rhsSCZfo", forHTTPHeaderField: "X-Naver-Client-Secret")
//    urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//    var data = Data()
//    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//    data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
//    data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
//    data.append(pngImage)
//    data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

//    session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
//        if error == nil {
//            if to == "celebrity" {
//                parseCelebrity(responseData: responseData!, img: pngImage)
//
//            }else if to == "face" {
//                parseFace(responseData: responseData!, img: pngImage)
//            }
//        }
//    }).resume()
//}


//https://www.it-gundan.com/ko/ios/swift%EC%97%90%EC%84%9C-json-%EB%B0%B0%EC%97%B4%EC%9D%84-%EB%B0%B0%EC%97%B4%EB%A1%9C-%EA%B5%AC%EB%AC%B8-%EB%B6%84%EC%84%9D%ED%95%98%EB%8A%94-%EB%B0%A9%EB%B2%95/830328697/amp/
 
