//
//  Task.swift
//  BookTalk
//
//  Created by 김민 on 8/14/24.
//

import Foundation
import Alamofire

enum Task {
    /// 추가 데이터가 없는 request
    case requestPlain
    /// Encodable을 채택하는 body를 포함하는 request
    case requestJSONEncodable(body: Encodable)
    /// Parameter을 포함하는 request
    case requestParameters(parameters: Parameters)
}
