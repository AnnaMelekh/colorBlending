//
//  NetworkService.swift
//  colorBlending
//
//  Created by Anna Melekhina on 21.01.2025.
//

import Foundation
import Alamofire

struct NetworkService {
    
    func fetchData(red: Int, green: Int, blue: Int, completion: @escaping (String?) -> Void) {
         guard let url = createURL(red: red, green: green, blue: blue) else {
            return
        }
        
        AF.request(url).responseDecodable(of: ColorData.self) { response in
            switch response.result {
            case .success(let colorData):
                 let colorName = colorData.name?.value
                completion(colorName)
            case .failure(let error):
                print("Ошибка при запросе: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func createURL(red: Int, green: Int, blue: Int) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.thecolorapi.com"
        components.path = "/id"
        
         components.queryItems = [
            URLQueryItem(name: "rgb", value: "\(red),\(green),\(blue)"),
            URLQueryItem(name: "format", value: "json")
        ]
        
        return components.url
    }
}
