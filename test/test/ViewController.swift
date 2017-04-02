//
//  ViewController.swift
//  test
//
//  Created by Xinyu Qu on 4/3/17.
//  Copyright © 2017 Xinyu Qu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var startPoint:CGPoint = CGPointFromString("0")
    
    var layer:CAShapeLayer?
    
    var configG:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func degree2radian(a:CGFloat)->CGFloat{
        let ret = CGFloat(M_PI) * a/180
        return ret
    }
    
    
    func polyPoints(sides: Int, x:CGFloat, y:CGFloat, radius:CGFloat, adjustment:CGFloat = 0)->[CGPoint]
    {
        let angle = degree2radian(a: 360/CGFloat(sides))
        let cx = x
        let cy = y
        let r = radius
        var i = sides
        var points = [CGPoint]()
        
        while points.count <= sides{
            let xpo = cx - r * cos(angle * CGFloat(i) + degree2radian(a: adjustment))
            let ypo = cy - r * sin(angle * CGFloat(i) + degree2radian(a: adjustment))
            points.append(CGPoint(x:xpo, y:ypo))
            i -= 1
        }
        return points
        
    }
    
    
    func polygonPath(x: CGFloat, y:CGFloat, radius:CGFloat, sides:Int, offset:CGFloat)->CGPath
    {
        let path = CGMutablePath()
        let points = polyPoints(sides: sides, x: x, y: y, radius: radius, adjustment: offset)
        let cpg = points[0]
        path.move(to: cpg)
        
        for p in points{
            path.addLine(to: p)
        }
        
        path.closeSubpath()
        
        return path
        
    }
    
    
    
    @IBAction func operation(_ sender: UIPanGestureRecognizer) {
        
        if sender.state == .began
        {
            startPoint = sender .location(in: sender.view)
            layer = CAShapeLayer()
            layer?.fillColor = UIColor.red.cgColor
            layer?.opacity = 0.2
            layer?.strokeColor = UIColor.blue.cgColor
            self.view.layer.addSublayer(layer!)
        }
        else if sender.state == .changed
        {
            let translation = sender .translation(in: sender.view)
            
            let endPoint:CGPoint = sender.location(in: sender.view)
            
            switch configG{
            case 1:
                //for oval
                layer?.path = (UIBezierPath(ovalIn:CGRect(x:startPoint.x,
                                                          y: startPoint.y,
                                                          width: translation.x,
                                                          height: translation.y))).cgPath
            case 2:
                layer?.path = (UIBezierPath(rect:CGRect(x:startPoint.x,
                                                          y: startPoint.y,
                                                          width: translation.x,
                                                          height: translation.y))).cgPath

            case 3: //line
                
                let linePath = UIBezierPath()
                linePath.move(to: startPoint)
                linePath.addLine(to: endPoint)
                layer?.path = linePath.cgPath
            
            case 4: //triangle
                let trianglepath = polygonPath(x: startPoint.x, y:startPoint.y, radius: translation.x/3, sides: 3, offset: 0)
                let tPath = UIBezierPath(cgPath:trianglepath)
                
               layer?.path = tPath.cgPath
            
            case 5: //diamond
                let diamondPath = polygonPath(x: startPoint.x, y:startPoint.y, radius: translation.x/4, sides: 4, offset: 0)
                let diamondBezierpath = UIBezierPath(cgPath:diamondPath)
                
                layer?.path = diamondBezierpath.cgPath

            case 6: //star
                let starPath = polygonPath(x: startPoint.x, y:startPoint.y, radius: translation.x/10, sides: 6, offset: 2)
                let starBezierPath = UIBezierPath(cgPath:starPath)
                
                layer?.path = starBezierPath.cgPath
                
            default:
                print("no idea")
                
            }
           
        }
    }
    
    

    @IBAction func globalConfig(_ sender: UIButton) {
        
        configG = 6
    }

}

