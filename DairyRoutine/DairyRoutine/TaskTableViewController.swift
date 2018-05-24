//
//  TaskTableViewController.swift
//  Hello World
//
//  Created by Qing Zhang on 5/21/18.
//  Copyright © 2018 Qing Zhang. All rights reserved.
//

import UIKit
import os.log

class TaskTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleTasks()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "TaskTableViewCell"
        
        /* let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)*/

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TaskTableViewCell else {
                fatalError("The dequeued cell is not an instance of TaskTableViewCell")
        }
        
        //Fetch the appropriate task for the data source layout
        let task = tasks[indexPath.row]
        
        cell.nameLabel.text = task.name
        cell.nameImage.image = task.photo
        cell.descLabel.text = task.desc

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Private Methods
    
    private func loadSampleTasks() {
        let wakeupImage = UIImage(named: "wakeup")
        let morningrunImage = UIImage(named: "morning_run")
        let drinkwaterImage = UIImage(named: "drinkwater")
        let breakfastImage = UIImage(named: "breakfast")
        let stretchImage = UIImage(named: "stretch")
        let meditationImage = UIImage(named: "meditation")
        let bedtimeImage = UIImage(named: "bedtime")
        let snackImage = UIImage(named: "snack")
        
        
        guard let wakeuptask = Task(name: "Wake Up", photo: wakeupImage!, desc: "5:00 am")
            else {
                fatalError("Unable to instantiate wakeup task")
        }
        
        guard let morningruntask = Task(name: "Morning Exercise", photo: morningrunImage!,desc: "7am")
            else {
                fatalError("Unable to instantiate morning exercise task")
        }
        
        guard let drinkwatertask = Task(name: "Drink Water", photo: drinkwaterImage!, desc: "every hour from 9am-5pm")
            else {
                fatalError("Unable to instantiate drink water task")
        }
        
        guard let breakfasttask = Task(name: "Breakfast", photo: breakfastImage!, desc: "8am")
            else {
                fatalError("Unable to instantiate Breakfast task")
        }
        
        guard let stretchtask = Task(name: "Stretch", photo: stretchImage!, desc: "every hour from 10am-4pm")
            else {
                fatalError("Unable to instantiate Stretch task")
        }
        
        guard let meditationtask = Task(name: "Meditation", photo: meditationImage!, desc: "5:15am")
            else {
                fatalError("Unable to instantiate Meditation task")
        }
        
        guard let snacktask = Task(name: "Snack", photo: snackImage!, desc: "10:30am, 3:00pm")
            else {
                fatalError("Unable to instantiate Snack task")
        }
        
        guard let bedtimetask = Task(name: "Bedtime", photo: bedtimeImage!, desc: "10pm")
            else {
                fatalError("Unable to instantiate Bedtime task")
        }
        
        tasks += [wakeuptask, morningruntask, drinkwatertask, breakfasttask, stretchtask, meditationtask, snacktask, bedtimetask]
        
    }
    
    //MARK: Actions
    
    @IBAction func unwindToTaskList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? TaskDetailViewController, let task = sourceViewController.task {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // update an existing meal
                tasks[selectedIndexPath.row] = task
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new task
                let newIndexPath = IndexPath(row: tasks.count, section: 0)
                
                tasks.append(task)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        print(sender.source)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often weant to do a little prepareation before nagivation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            case "AddItem":
                os_log("Adding a new task.", log: OSLog.default, type: .debug)
            
            case "showDetail":
                os_log("Show task detail...")
                guard let taskDetailViewController = segue.destination as? TaskDetailViewController
                    else {
                        fatalError("Unexpected destination: \(segue.destination)")
                    }
            
                guard let selectedTaskCell = sender as? TaskTableViewCell else {
                        fatalError("Unexpected sender: \(sender)")
                }
            
                guard let indexPath = tableView.indexPath(for: selectedTaskCell) else {
                        fatalError("The selected cell is not being displayed by the table")
                }
            
                let selectedTask = tasks[indexPath.row]
                taskDetailViewController.task = selectedTask
            
            default:
                fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
        
            
        
    }
    
}
