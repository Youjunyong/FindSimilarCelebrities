//
//  nsdata.swift
//  FindSimilarCelebrities
//
//  Created by 유준용 on 2021/09/19.
//

import Foundation



func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
  let data = NSMutableData()
    

  // ⭐️ 이미지가 여러 장일 경우 for 문을 이용해 data에 append 해줍니다.
  // (현재는 이미지 파일 한 개를 data에 추가하는 코드)

  data.appendString("--\(boundary)\r\n")
  data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
  data.appendString("Content-Type: \(mimeType)\r\n\r\n")
  data.append(fileData)
  data.appendString("\r\n")

  return data as Data
}

extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
