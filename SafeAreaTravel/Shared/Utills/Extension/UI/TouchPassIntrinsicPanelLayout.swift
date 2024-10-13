//
//  PassThroughView.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/23/24.
//

import FloatingPanel

final class TouchPassIntrinsicPanelLayout: FloatingPanelBottomLayout {
    override var initialState: FloatingPanelState { .half }
    override var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
        return [
            .tip: FloatingPanelIntrinsicLayoutAnchor(fractionalOffset: 0, referenceGuide: .safeArea),
            .half: FloatingPanelIntrinsicLayoutAnchor(absoluteOffset: 200, referenceGuide: .safeArea)
        ]
    }
}
