//
//  WindowDirection+Snapping.swift
//  Loop
//
//  Created by Kai Azim on 2024-06-09.
//

import Foundation

extension WindowDirection {
    static func getSnapDirection(
        mouseLocation: CGPoint,
        currentDirection: WindowDirection,
        screenFrame: CGRect,
        ignoredFrame: CGRect
    ) -> WindowDirection {
        var newDirection: WindowDirection = .noAction

        if mouseLocation.x < ignoredFrame.minX {
            newDirection = processSideSnap(mouseLocation, screenFrame, currentDirection, isLeft: true)
        } else if mouseLocation.x > ignoredFrame.maxX {
            newDirection = processSideSnap(mouseLocation, screenFrame, currentDirection, isLeft: false)
        } else if mouseLocation.y < ignoredFrame.minY {
            newDirection = processTopSnap(mouseLocation, screenFrame)
        } else if mouseLocation.y > ignoredFrame.maxY {
            newDirection = processBottomSnap(mouseLocation, screenFrame, currentDirection)
        }

        return newDirection
    }

    private static func processThirdsSnapping(
        mousePos: CGFloat,
        maxPos: CGFloat,
        totalLength: CGFloat,
        currentDirection: WindowDirection,
        firstThird: WindowDirection,
        secondThird: WindowDirection,
        firstTwoThirds: WindowDirection,
        secondTwoThirds: WindowDirection,
        defaultHalf: WindowDirection
    ) -> WindowDirection {
        if mousePos < maxPos - (totalLength * 2 / 3) {
            return firstThird
        } else if mousePos > maxPos - (totalLength * 1 / 3) {
            return secondThird
        } else {
            if currentDirection == firstThird || currentDirection == firstTwoThirds {
                return firstTwoThirds
            } else if currentDirection == secondThird || currentDirection == secondTwoThirds {
                return secondTwoThirds
            }
            return defaultHalf
        }
    }

    private static func processSideSnap(
        _ mouseLocation: CGPoint,
        _ screenFrame: CGRect,
        _ currentDirection: WindowDirection,
        isLeft: Bool
    ) -> WindowDirection {
        let mouseY = mouseLocation.y
        let maxY = screenFrame.maxY
        let height = screenFrame.height

        if height > screenFrame.width {
            if mouseY < maxY - (height * 7 / 8) {
                return isLeft ? .topLeftQuarter : .topRightQuarter
            }
            if mouseY > maxY - (height * 1 / 8) {
                return isLeft ? .bottomLeftQuarter : .bottomRightQuarter
            }
            if mouseY < maxY - (height * 2 / 3) {
                return .topHalf
            }
            if mouseY > maxY - (height * 1 / 3) {
                return .bottomHalf
            }
            if mouseY < maxY - (height * 7 / 12) {
                if currentDirection == .topThird || currentDirection == .topTwoThirds {
                    return .topTwoThirds
                }
                return .topThird
            }
            if mouseY > maxY - (height * 5 / 12) {
                if currentDirection == .bottomThird || currentDirection == .bottomTwoThirds {
                    return .bottomTwoThirds
                }
                return .bottomThird
            }
            return .verticalCenterThird
        }

        if mouseY < maxY - (height * 7 / 8) {
            return isLeft ? .topLeftQuarter : .topRightQuarter
        }
        if mouseY > maxY - (height * 1 / 8) {
            return isLeft ? .bottomLeftQuarter : .bottomRightQuarter
        }
        return isLeft ? .leftHalf : .rightHalf
    }

    private static func processTopSnap(
        _ mouseLocation: CGPoint,
        _ screenFrame: CGRect
    ) -> WindowDirection {
        let mouseX = mouseLocation.x
        let maxX = screenFrame.maxX
        let width = screenFrame.width

        if mouseX < maxX - (width * 4 / 5) || mouseX > maxX - (width * 1 / 5) {
            return .topHalf
        }
        return .maximize
    }

    private static func processBottomSnap(
        _ mouseLocation: CGPoint,
        _ screenFrame: CGRect,
        _ currentDirection: WindowDirection
    ) -> WindowDirection {
        return processThirdsSnapping(
            mousePos: mouseLocation.x,
            maxPos: screenFrame.maxX,
            totalLength: screenFrame.width,
            currentDirection: currentDirection,
            firstThird: .leftThird,
            secondThird: .rightThird,
            firstTwoThirds: .leftTwoThirds,
            secondTwoThirds: .rightTwoThirds,
            defaultHalf: .bottomHalf
        )
    }
}
