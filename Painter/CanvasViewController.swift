//
//  CanvasViewController.swift
//  Painter
//
//  Created by sodas on 10/31/16.
//  Copyright © 2016 sodastsai. All rights reserved.
//

import Cocoa

class CanvasViewController: NSViewController {

    let canvasWidth = 480
    let canvasHeight = 320
    var currentRectanglesCount = 5 {
        didSet {
            self.generateDrawables()
            self.drawAsImage()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(rectanglesCountChanged(_:)),
                                               name: Notification.Name.WindowControllerRectanglesCountDidChange,
                                               object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.generateDrawables()
        self.drawAsImage()
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.WindowControllerRectanglesCountDidChange,
                                                  object: nil)
    }

    func rectanglesCountChanged(_ notification: Notification) {
        guard let changedRectanglesCount = notification.userInfo?["value"] as? Int else {
            return
        }
        guard self.currentRectanglesCount != changedRectanglesCount else {
            return
        }
        self.currentRectanglesCount = changedRectanglesCount
    }

    // MARK: Random create

    var drawables: [CanvasDrawable] = []

    func generateDrawables() {
        self.drawables = []
        for _ in 0..<self.currentRectanglesCount {
            let drawable = CanvasDrawable(randomlyWithXBound: Double(self.canvasWidth),
                                          yBound: Double(self.canvasHeight),
                                          widthBound: Double(self.canvasWidth)/2.0,
                                          heightBound: Double(self.canvasHeight)/2.0)
            self.drawables.append(drawable)
        }
    }

    // MARK: Draw as Image

    @IBOutlet weak var imageView: NSImageView!

    var contextSize: NSSize {
        let width = self.drawables.map { $0.rect.origin.x + $0.rect.size.width }.max() ?? 0
        let height = self.drawables.map { $0.rect.origin.y + $0.rect.size.height }.max() ?? 0
        return NSSize(width: width + 20, height: height + 20)
    }

    func drawAsImage() {
        let bitsPerComponent = 8
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo: CGBitmapInfo = [
            CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        ]
        let contextSize = self.contextSize
        guard let context = CGContext(data: nil,
                                      width: Int(contextSize.width), height: Int(contextSize.height),
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: Int(contextSize.width)*4*bitsPerComponent/8,
                                      space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
                                        return
        }

        context.setFillColor(NSColor.white.cgColor)
        context.fill(CGRect(origin: CGPoint.zero, size: contextSize))

        self.drawables.draw(with: context)
        guard let cgImage = context.makeImage() else {
            return
        }
        self.imageView.image = NSImage(cgImage: cgImage, size: contextSize)
    }

    // MARK: - I/O Helper

    func chooseOutputDestination(completion: @escaping (URL) -> Void) {
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = "Untitled.pdf"
        savePanel.beginSheetModal(for: self.view.window!) { result in
            if result == NSFileHandlingPanelOKButton {
                completion(savePanel.url!)
            }
        }
    }

    @IBAction func saveCanvas(_ sender: Any?) {
        self.chooseOutputDestination() { url in
            self.drawAsPDF(at: url)
        }
    }

    func drawAsPDF(at fileURL: URL) {
        let contextSize = self.contextSize
        var mediaBox = CGRect(x: 0, y: 0, width: contextSize.width, height: contextSize.height)
        guard let context = CGContext(fileURL as CFURL, mediaBox: &mediaBox, nil) else {
            return
        }
        defer {
            context.closePDF()
        }

        context.beginPDFPage(nil)
        self.drawables.draw(with: context)
        context.endPDFPage()
    }

}
