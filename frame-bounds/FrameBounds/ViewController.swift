//
//  ViewController.swift
//  FrameBounds
//
//  Created by 전현성 on 2023/01/17.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawView()
//        changeFrame()
//        changeBounds()
    }
    
    func drawView() {
        self.view.backgroundColor = .orange
        self.view.addSubview(firstView)
        firstView.addSubview(secondView)
    }
    
    func changeFrame() {
        printFrame()
        firstView.frame.origin.x = 50
        firstView.frame.origin.y = 200
        print("Change")
        printFrame()
    }
    
    func changeBounds() {
        printAll()
        firstView.bounds.origin.x = 50
        firstView.bounds.origin.y = 200
        print("Change")
        printAll()
    }
    
    func printAll() {
        printFrame()
        printBounds()
    }
    
    func printFrame() {
        print("-------------------------")
        print("Frame")
        let firstViewFrameX = firstView.frame.origin.x
        let firstViewFrameY = firstView.frame.origin.y
        print("firstView Frame -> x = \(firstViewFrameX), y = \(firstViewFrameY)")
        
        let secondViewFrameX = secondView.frame.origin.x
        let secondViewFrameY = secondView.frame.origin.y
        print("secondView Frame -> x = \(secondViewFrameX), y = \(secondViewFrameY)")
        print("-------------------------")
    }
    
    func printBounds() {
        print("-------------------------")
        print("Bounds")
        let firstViewBoundsX = firstView.bounds.origin.x
        let firstViewBoundsY = firstView.bounds.origin.y
        print("firstView Bounds -> x = \(firstViewBoundsX), y = \(firstViewBoundsY)")
        
        let secondViewBoundsX = secondView.bounds.origin.x
        let secondViewBoundsY = secondView.bounds.origin.y
        print("secondView Bounds -> x = \(secondViewBoundsX), y = \(secondViewBoundsY)")
        print("-------------------------")
    }
    
    // MARK: - View
    let firstView: UIView = {
        let view = UIView(frame: CGRect(x: 100, y: 100, width: 200, height: 300))
        view.backgroundColor = .red
        
        return view
    }()
    
    let secondView: UIView = {
        let view = UIView(frame: CGRect(x: 50, y: 75, width: 100, height: 150))
        view.backgroundColor = .blue
        
        return view
    }()
}

