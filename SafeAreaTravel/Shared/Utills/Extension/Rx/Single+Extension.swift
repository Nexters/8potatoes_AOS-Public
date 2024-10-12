//
//  Single+Extension.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 10/12/24.
//

import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element: DataResponse {
    /// Raw JSON을 로깅하는 확장 메서드
    /// - Parameter tag: 로그 태그
    /// - Returns: 로깅이 적용된 Single
    func logRawJSON(tag: String = "Raw JSON Response") -> Single<Element> {
        return self.do(onSuccess: { response in
            #if DEBUG
            if let jsonString = String(data: response.data, encoding: .utf8) {
                log.debug("\(tag): \(jsonString)")
            } else {
                log.error("응답 데이터를 문자열로 변환하는 데 실패했습니다.")
            }
            #endif
        }, onError: { error in
            #if DEBUG
            log.error("로깅 중 에러 발생: \(error.localizedDescription)")
            #endif
        })
    }
}
