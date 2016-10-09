//
//  MasterViewController.swift
//  TaskMatcher
//
//  Created by Jack McCracken on 2016-10-07.
//  Copyright © 2016 Jack McCracken. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, TaskReceiverDelegate {

    var detailViewController: DetailViewController? = nil
    var objects = [Activity]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: Any) {
        objects.insert(Activity(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // If we're not in a storyboard, this method shouldn't be called
        let navigationController = self.storyboard!.instantiateViewController(withIdentifier: "addTask") as! UINavigationController
        let addTaskController = navigationController.viewControllers[0] as! AddTaskController
        addTaskController.delegate = self

        // Needs to happen before we present the view if we're on an iPad
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            navigationController.modalPresentationStyle = UIModalPresentationStyle.popover
        }

        // Always present the view controller
        self.present(navigationController, animated: true)

        // This gives the popover the "anchor point"
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            let presentationController = navigationController.popoverPresentationController
            
            presentationController!.barButtonItem = self.navigationItem.rightBarButtonItem
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object.name
        cell.detailTextLabel!.text = String(object.duration)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    func receiveTask(task: Activity) {
        objects.append(task)
        self.tableView.reloadData()
    }
}

