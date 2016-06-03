//
//  ViewController.swift
//  FlowDemo
//
//  Created by Sebastien Orban on 03/06/16.
//  Copyright © 2016 Random Mechanicals. All rights reserved.
//

import UIKit
import CocoaFlow

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let textCellIdentifier = "TextCell"
    
    let testStore:Source<Int, Int> = Source(state: 0)
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath)
        
        //let row = indexPath.row
        let _ = testStore.addListener { (value:Int?) in
            cell.textLabel?.text = "value is : \(value)"
        }
        
        cell.textLabel?.text = "Initial text"
        
        return cell
    }


    override func viewDidLoad() {
        testStore.actions["inc"] = ({ (state:Int?, _) -> Int in
            guard let s = state else {return 0}
            return s + 1
        })
        testStore.actions["dec"] = ({ (state:Int?, _) -> Int in
            guard let s = state else {return 0}
            return s - 1
        })
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
            self.testStore.transact("inc")
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

