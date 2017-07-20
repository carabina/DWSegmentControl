//
//  ViewController.swift
//  DWSegmentControl
//
//  Created by Dawson Walker on 2017-07-20.
//  Copyright © 2017 Dawson Walker. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: DWSegmentControl!
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Handle 
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swiped(_:)))
        swipeRight.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swiped(_:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        
        //Delay allows for segmentControl to go to specific index and have the correct bar size
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.segmentControl.setInitialIndex(index: 0)
            self.segmentControl.isHidden = false
        }
        self.setUpObserver()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func setUpObserver() {
        self.segmentControl.currentIndexVariable.asObservable().subscribe(onNext: { /*[weak self]*/ val in
            print(val)//Index
        }).addDisposableTo(disposeBag)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func handleLeft() {
        if self.segmentControl.currentIndexVariable.value == 0 {
            self.segmentControl.changeIndex(index: 1)
        } else if self.segmentControl.currentIndexVariable.value == 1 {
            self.segmentControl.changeIndex(index: 2)
        }
    }
    func handleRight() {
        if self.segmentControl.currentIndexVariable.value == 1 {
            self.segmentControl.changeIndex(index: 0)
        } else if self.segmentControl.currentIndexVariable.value == 2 {
            self.segmentControl.changeIndex(index: 1)
        }
    }
    
    func swiped(_ gesture: UIGestureRecognizer) {
        if let gestureSwipe = gesture as? UISwipeGestureRecognizer {
            if gestureSwipe.direction == UISwipeGestureRecognizerDirection.right {
                handleRight()
            } else if gestureSwipe.direction == UISwipeGestureRecognizerDirection.left {
                handleLeft()
            }
        }
    }

}

