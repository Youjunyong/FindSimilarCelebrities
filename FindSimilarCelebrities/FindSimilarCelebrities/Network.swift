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

func parseFace(responseData: Data) -> [String: String] {
    var retDict: [String: String] = [:]
    if let jsonData = try? JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary {
        if let info = jsonData["info"] as? NSDictionary {
            retDict["faceCount"] = "\(String(describing: info["faceCount"]))"
        }
        let faces = jsonData["faces"] as? NSArray
        if let face = faces![0] as? NSDictionary{
            if let gender = face["gender"] as? NSDictionary{
                
                let value = gender["value"]  as! String
                let confidence = gender["confidence"] as! Double
                retDict["gender_v"] = value
                retDict["gender_c"] = "\(round(confidence * 10000)/100)%"
            }
            if let emotion = face["emotion"] as? NSDictionary{
                
                let value = emotion["value"]  as! String
                let confidence = emotion["confidence"] as! Double
                retDict["emotion_v"] = value
                retDict["emotion_c"] = "\(round(confidence * 10000)/100)%"
            }
//            emotion
            if let age = face["age"] as? NSDictionary{
                
                let value = age["value"]  as! String
                let confidence = age["confidence"] as! Double
                retDict["age_v"] = value
                retDict["age_c"] = "\(round(confidence * 10000)/100)%"
            }
//            age
            if let pose = face["pose"] as? NSDictionary{
                
                let value = pose["value"]  as! String
                let confidence = pose["confidence"] as! Double
                retDict["pose_v"] = value
                retDict["pose_c"] = "\(round(confidence * 10000)/100)%"
            }
//            pose
        }
    }
    return retDict
}
func parseCelebrity(responseData: Data) -> [String: String] {
    var retDict: [String: String] = [:]
    if let jsonData = try? JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary {
        if let info = jsonData["info"] as? NSDictionary {
            retDict["faceCount"] = "\(String(describing: info["faceCount"]))"
        }
        let faces = jsonData["faces"] as? NSArray
        if let face = faces![0] as? NSDictionary {
            if let celebrity = face["celebrity"] as? NSDictionary {
                let value = celebrity["value"] as! String
                let confidence = celebrity["confidence"] as! Double
                retDict["value"] = value
                retDict["confidence"] = "\(round(confidence * 10000)/100)%"
            }
        }
    }else{
        
    }
    return retDict
}

func uploadImage(paramName: String, fileName: String, image: UIImage, to: String) {
    // to : face or celebrity
    let url = URL(string: "https://openapi.naver.com/v1/vision/\(to)")
    let boundary = UUID().uuidString
    let session = URLSession.shared
    var urlRequest = URLRequest(url: url!)
    urlRequest.httpMethod = "POST"
    urlRequest.addValue("s9djJV1HxQ0PZJDEz_xH", forHTTPHeaderField: "X-Naver-Client-Id")
    urlRequest.addValue("K5rhsSCZfo", forHTTPHeaderField: "X-Naver-Client-Secret")
    urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    var data = Data()
    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
    data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
    data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
    data.append(image.pngData()!)
    data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

    session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
        if error == nil {
            if to == "celebrity" {
                let retDict = parseCelebrity(responseData: responseData!)
            }
            if to == "face" {
                let retDict = parseFace(responseData: responseData!)
                print(retDict)
            }
            

        }
    }).resume()
}


//https://www.it-gundan.com/ko/ios/swift%EC%97%90%EC%84%9C-json-%EB%B0%B0%EC%97%B4%EC%9D%84-%EB%B0%B0%EC%97%B4%EB%A1%9C-%EA%B5%AC%EB%AC%B8-%EB%B6%84%EC%84%9D%ED%95%98%EB%8A%94-%EB%B0%A9%EB%B2%95/830328697/amp/
 
