//
//  MissionControlSuppressionTests.swift
//  LoopTests
//
//  Created by Joshua Van Deren on 2026-09-26.
//

import CoreGraphics
@testable import Loop
import Testing

struct MissionControlSuppressionTests {
    @Test func ignoresPointsInsideTheDisplay() {
        let display = CGRect(x: 0, y: 0, width: 1000, height: 800)

        #expect(WindowDragManager.topEdgeY(at: CGPoint(x: 100, y: 10), displayFrames: [display]) == nil)
    }

    @Test func returnsTheTopEdgeWhenThePointerIsOnIt() {
        let display = CGRect(x: 0, y: 0, width: 1000, height: 800)

        #expect(WindowDragManager.topEdgeY(at: CGPoint(x: 100, y: 0), displayFrames: [display]) == 0)
    }

    @Test func returnsTheTopEdgeWhenThePointerIsSlightlyPastIt() {
        let display = CGRect(x: 0, y: 0, width: 1000, height: 800)

        #expect(WindowDragManager.topEdgeY(at: CGPoint(x: 100, y: -0.5), displayFrames: [display]) == 0)
    }

    @Test func ignoresPointsWellAboveTheDisplay() {
        let display = CGRect(x: 0, y: 0, width: 1000, height: 800)

        #expect(WindowDragManager.topEdgeY(at: CGPoint(x: 100, y: -2), displayFrames: [display]) == nil)
    }

    @Test func usesTheLowerDisplayWhenStackedDisplaysMeet() {
        let upper = CGRect(x: 0, y: -800, width: 1000, height: 800)
        let lower = CGRect(x: 0, y: 0, width: 1000, height: 800)

        // y = 0 is the lower display's top and the upper display's bottom.
        #expect(WindowDragManager.topEdgeY(at: CGPoint(x: 100, y: 0), displayFrames: [upper, lower]) == 0)
    }

    @Test func usesTheNearestTopEdgeWhenDisplaysShareACorner() {
        let left = CGRect(x: 0, y: 0, width: 1000, height: 800)
        let right = CGRect(x: 1000, y: 0.4, width: 1000, height: 800)
        let corner = CGPoint(x: 1000, y: 0)

        #expect(WindowDragManager.topEdgeY(at: corner, displayFrames: [left, right]) == 0)
    }
}
