//
//  HorizontalBarChart.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 3/7/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit

class HorizontalBarChart: UIView {

    private let mainLayer: CALayer = CALayer()
    private let scrollView: UIScrollView = UIScrollView()
    let space: CGFloat = 20.0
    let barHeight: CGFloat = 15
    let contentSpace: CGFloat = 20
    
    var dataEntries: [HorizontalBarEntry] = [] {
        didSet {
            mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
            scrollView.contentSize = CGSize(width: self.frame.size.width, height:
                barHeight + space * CGFloat(dataEntries.count) + contentSpace)
            mainLayer.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height:
                scrollView.contentSize.height)
            for i in 0..<dataEntries.count {
                showEntry(index: i, entry: dataEntries[i])
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        setupView()
    }
    private func setupView() {
        scrollView.layer.addSublayer(mainLayer)
        self.addSubview(scrollView)
    }
    override func layoutSubviews() {
        scrollView.frame = CGRect(x: 0, y: 0, width: frame.size.width,
                                  height: frame.size.height)
    }
    
    private func showEntry(index: Int, entry: HorizontalBarEntry) {
        let xPos: CGFloat = translateWidthValueToXPosition(value:
            Float(entry.score) / Float(100000.0))
        
        let yPos: CGFloat = space + CGFloat(index) * (barHeight + space)
        
        drawBar(xPos: xPos, yPos: yPos)
        
        drawTextValue(xPos: xPos + 43, yPos: yPos, textValue: "\(entry.score)")
        
        drawTitle(xPos: 0, yPos: yPos, width: 38, height:
            15, title: entry.title)
    }
    
    private func drawBar(xPos: CGFloat, yPos: CGFloat) {
        let barLayer = CALayer()
        barLayer.frame = CGRect(x: 42 , y: yPos, width: xPos, height: 15)
        barLayer.backgroundColor = UIColor.black.cgColor
        barLayer.cornerRadius = 10
        barLayer.masksToBounds = true
        mainLayer.addSublayer(barLayer)
    }
    
    private func drawTextValue(xPos: CGFloat, yPos: CGFloat, textValue: String) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: yPos, width: 33, height: 15)
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = UIFont(name: "NotoSans", size: 10)
        textLayer.fontSize = 8
        textLayer.string = textValue
        mainLayer.addSublayer(textLayer)
    }
    
    private func drawTitle(xPos: CGFloat, yPos: CGFloat, width: CGFloat, height: CGFloat = 22, title: String) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.left
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = UIFont(name: "NotoSans-Medium", size: 10)
        textLayer.fontSize = 8
        textLayer.string = title
        mainLayer.addSublayer(textLayer)
    }
    
    private func translateWidthValueToXPosition(value: Float) -> CGFloat
    {
        let width = CGFloat(value) * (mainLayer.frame.width - space)
        return abs(width)
       
    }
}
