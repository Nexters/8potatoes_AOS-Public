//
//  Networking.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/21/24.
//

import RxSwift
import Moya
import RxMoya

final class Networking {
    
    private let provider = MoyaProvider<SafeAraAPI>()

    func request(
        _ target: SafeAraAPI,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) -> Single<Response> {
        let requestString = "\(target.method.rawValue) \(target.path)"
        
        /// 요청 바디를 추출하여 로그 출력
        var requestBody: String = ""
        if let request = try? provider.endpoint(target).urlRequest(),
        let httpBody = request.httpBody {
        requestBody = String(data: httpBody, encoding: .utf8) ?? "Cannot parse body"
        } else {
        requestBody = "No body"
        }
        
        return provider.rx.request(target)
            .catchAPIError(APIErrorResponse.self)
            .filterSuccessfulStatusCodes()
            .do(
                onSuccess: { value in
                    let message = "SUCCESS: \(requestString) (\(value.statusCode))"
                    log.debug(message, file: file, function: function, line: line)
                },
                onError: { error in
                    if let response = (error as? MoyaError)?.response {
                        if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)"
                            log.warning(message, file: file, function: function, line: line)
                        } else if let rawString = String(data: response.data, encoding: .utf8) {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
                            log.warning(message, file: file, function: function, line: line)
                        } else {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))"
                            log.warning(message, file: file, function: function, line: line)
                        }
                    } else {
                        let message = "FAILURE: \(requestString)\n\(error)"
                        log.warning(message, file: file, function: function, line: line)
                    }
                },
                onSubscribed: {
                    let message = """
                    ✈️ REQUEST API : \(requestString)
                    💪🏻 Body: \(requestBody)
                    """
                    log.info(message)
                }
            )
    }
}
