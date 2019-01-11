//
//  CityManagerViewController.swift
//  My Weather Diary
//
//  Created by zyh on 2019/1/10.
//  Copyright © 2019 njuzyh. All rights reserved.
//

import UIKit

class DiaryManagerViewController: UITableViewController, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func saveDiary(_ sender: Any) {
    }
    
    var diaries = ["Beijing", "ShangHai", "Nanjing", "GuangZhou", "HangZhou"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressAction))
        longPress.delegate = self
        longPress.minimumPressDuration = 1
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addGestureRecognizer(longPress)
        // Do any additional setup after loading the view.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEditing {
            return diaries.count + 1
        }
        return diaries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "diarycell", for: indexPath) as UITableViewCell
        if tableView.isEditing && indexPath.row == diaries.count {
            cell.textLabel?.text = "添加新数据..."
        }
        else
        {
            //cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = self.diaries[indexPath.row]
        }
        return cell
    }
    
    // 进入编辑模式，按下编辑按钮后执行
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            self.diaries.remove(at: indexPath.row)
            //刷新tableview
            tableView.setEditing(false, animated: true)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        else if editingStyle == UITableViewCell.EditingStyle.insert
        {
            self.diaries.append("新的日记")
            tableView.setEditing(false, animated: true)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        if tableView.isEditing == false {
            return UITableViewCell.EditingStyle.none
        }
        else if indexPath.row == diaries.count {
            return UITableViewCell.EditingStyle.insert
        }else {
            return UITableViewCell.EditingStyle.delete
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?{
        return "确认删除"
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath)
        print("点击了 \(cell?.textLabel?.text ?? "")")
        performSegue(withIdentifier: "showDiary", sender: nil)
    }
    
    
    @objc func longPressAction(recognizer:UILongPressGestureRecognizer)  {
        if recognizer.state == UIGestureRecognizer.State.began {
            print("UIGestureRecognizerStateBegan");
        }
        if recognizer.state == UIGestureRecognizer.State.changed {
            print("UIGestureRecognizerStateChanged");
        }
        if recognizer.state == UIGestureRecognizer.State.ended {
            print("UIGestureRecognizerStateEnded");
            if tableView.isEditing == true {
                tableView.isEditing = false
            }
            else
            {
                tableView.isEditing = true
            }
            tableView.reloadData()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
