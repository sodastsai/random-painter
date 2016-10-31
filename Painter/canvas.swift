//
//  canvas.swift
//  Painter
//
//  Created by sodas on 10/31/16.
//  Copyright © 2016 sodastsai. All rights reserved.
//

import CoreGraphics.CGContext
import AppKit.NSColor

// MARK: - Refined for Swift

extension CanvasColor {
    init?(from values: [Double]) {
        guard values.count == 4 else {
            return nil
        }
        var _values = values
        self = __CVCanvasColorFromRGBAValues(&_values)
    }
}

// MARK: - Swift Protocols and Helpers

extension CanvasPoint: CustomStringConvertible {
    public var description: String {
        return "(\(self.x), \(self.y))"
    }
}
extension CGPoint {
    init(_ canvasPoint: CanvasPoint) {
        self.init(x: canvasPoint.x, y: canvasPoint.y)
    }
}

extension CanvasSize: CustomStringConvertible {
    public var description: String {
        return "(w=\(self.width), h=\(self.height))"
    }
}
extension CGSize {
    init(_ canvasSize: CanvasSize) {
        self.init(width: canvasSize.width, height: canvasSize.height)
    }
}

extension CanvasRect: CustomStringConvertible {
    public var description: String {
        return "(origin=\(self.origin), size=\(self.size))"
    }
}
extension CGRect {
    init(_ canvasRect: CanvasRect) {
        self.init(origin: CGPoint(canvasRect.origin), size: CGSize(canvasRect.size))
    }
}

extension CanvasColor: CustomStringConvertible {
    public var description: String {
        return "{r=\(self.r), g=\(self.g), b=\(self.b), a=\(self.a)}"
    }
}
extension CanvasColor {
    var nsColor: NSColor {
        return NSColor(red: CGFloat(self.r),
                       green: CGFloat(self.g),
                       blue: CGFloat(self.b),
                       alpha: CGFloat(self.a))
    }
    var cgColor: CGColor {
        return self.nsColor.cgColor
    }
}

// MARK: - Canvas Draw

protocol Drawable {
    func draw(with context: CGContext)
}

extension CanvasDrawable: Drawable {
    func draw(with context: CGContext) {
        context.saveGState()
        defer {
            context.restoreGState()
        }

        context.setFillColor(self.fillColor.cgColor)
        context.fill(CGRect(self.rect))
        context.setStrokeColor(self.strokeColor.cgColor)
        context.stroke(CGRect(self.rect), width: CGFloat(self.strokeWidth))
    }
}

extension Collection where Self.Iterator.Element: Drawable {
    func draw(with context: CGContext) {
        for drawable in self {
            context.saveGState()
            defer {
                context.restoreGState()
            }
            drawable.draw(with: context)
        }
    }
}
