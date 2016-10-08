//
//  AddTaskController.swift
//  TaskMatcher
//
//  Created by Jack McCracken on 2016-10-07.
//  Copyright © 2016 Jack McCracken. All rights reserved.
//

import Foundation
import UIKit

protocol TaskReceiverDelegate {
    func receiveTask(task: Activity)
}

class AddTaskController : UIViewController {
    var delegate : TaskReceiverDelegate?
    
    override func viewDidLoad() {
        
    }
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        // Adding a task without a place to send the data
        // doesn't make sense.
        delegate!.receiveTask(task: Activity())

        self.dismiss(animated: true)
    }
}
