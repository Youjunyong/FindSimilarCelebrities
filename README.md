# FindSimilarCelebrities


## 개요

ios와 서버와의 HTTP 통신을 공부하고, Open API를 사용한 간단한 앱을 만들어보고 싶었다.
Naver Open API https://developers.naver.com/docs/common/openapiguide/  


## Naver API

요청 방법은 네이버 api 링크에서 자세하게 설명 되어있다.



> curl

```shell
curl "https://openapi.naver.com/v1/util/shorturl" \
    -d "url=http://d2.naver.com/helloworld/4874130" \
    -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" \
    -H "X-Naver-Client-Id: {애플리케이션 등록 시 발급받은 클라이언트 아이디 값}" \
    -H "X-Naver-Client-Secret: {애플리케이션 등록 시 발급받은 클라이언트 시크릿 값}" -v
```

curl로 응답을 받아보면

> 응답

```json
{
    "message":"ok",
    "result": {
        "hash":"GyvykVAu",
        "url":"https://me2.do/GyvykVAu",
        "orgUrl":"http://d2.naver.com/helloworld/4874130"
    }
    ,"code":"200"
}
```




Fetching Website Data into Memory
https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory


```swift
struct Response: Codable {
        struct Container : Codable{
            var orgUrl : String
            var url : String
            var hash : String
        }
        
        var result : Container
        let message : String
        let code: String
    }
```





```swift
func requestGet(query: String, completionHandler: @escaping (Bool, Any) -> Void) {
        let clientID = "클라이언트 ID"
        let clientSecret = "클라이언트 secret"
        // naver에서 애플리케이션 등록을하면 알려준다.
        let apiUrl : String = "https://openapi.naver.com/v1/util/shorturl.json?url=\(query)"
  
        guard let encodedUrl = apiUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        // URL에 한글이 들어갈 경우를 대비해서 encoding을 해줘야한다.
        
            return
        }
        guard let url = URL(string: encodedUrl) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                return
            }
            guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
                return
            }
            completionHandler(true, output)
        }.resume()
    }
```

