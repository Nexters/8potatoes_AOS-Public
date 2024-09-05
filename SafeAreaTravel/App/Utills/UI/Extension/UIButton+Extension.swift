//
//  UIButton+Extension.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 9/3/24.
//

import UIKit

extension UIButton {
    /// 하이라이트 상태에서 이미지가 변경되지 않도록 설정하는 메소드
    func disableImageHighlightEffect() {
        /// 버튼의 초기 configuration을 가져오거나 새로 생성
        var configuration = self.configuration ?? UIButton.Configuration.plain()

        /// configuration의 image가 설정되지 않은 경우, 현재 상태에서 설정된 이미지를 가져와 설정
        if configuration.image == nil {
            configuration.image = self.image(for: .normal)
        }
        self.configuration = configuration

        /// configurationUpdateHandler 설정
        self.configurationUpdateHandler = { button in
            var updatedConfiguration = button.configuration
            if button.isHighlighted {
                updatedConfiguration?.image = configuration.image
            } else {
                updatedConfiguration?.image = configuration.image
            }
            button.configuration = updatedConfiguration
        }
    }
}
