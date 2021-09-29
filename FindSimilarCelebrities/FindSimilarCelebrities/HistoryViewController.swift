//
//  HistoryViewController.swift
//  FindSimilarCelebrities
//
//  Created by 유준용 on 2021/09/28.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBAction func delTouched(_ sender: UIButton) {
        let contentView = sender.superview
        if let cell = contentView?.superview as? UITableViewCell{
            if let tableView = cell.superview as? UITableView{
                if let indexPath = tableView.indexPath(for: cell) {
                    DataManager.shared.delRecord(DataManager.shared.recordList[indexPath.row])
                    DataManager.shared.fetchRecord()
                    tableView.reloadData()
                }
            }
        }
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        DataManager.shared.fetchRecord()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DataManager.shared.fetchRecord()
        tableView.reloadData()
    }
    
    
}
extension HistoryViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let DetailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else{return}
        self.present(DetailVC, animated: true, completion: nil)
    }
}
extension HistoryViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.recordList.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "hCell") else{return UITableViewCell()}
        if let imageView = cell.viewWithTag(1) as? UIImageView{
            imageView.layer.cornerRadius = imageView.frame.size.height / 2
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 3.0
            imageView.layer.borderColor = CGColor(red: 1.0, green: 0, blue: 0, alpha: 1)
            imageView.image = UIImage(data: DataManager.shared.recordList[indexPath.row].image!)
        }
        if let celebrityLabel = cell.viewWithTag(2) as? UILabel{
            celebrityLabel.text = DataManager.shared.recordList[indexPath.row].celebrityValue!
        }
        if let ageLabel = cell.viewWithTag(3) as? UILabel{
            ageLabel.text = DataManager.shared.recordList[indexPath.row].faceAgeValue! + "세"
        }
        if let dateLabel = cell.viewWithTag(4) as? UILabel{
            let date = DataManager.shared.recordList[indexPath.row].date!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM월 dd일"
            dateLabel.text = dateFormatter.string(from: date)
        }
        if let delBtn = cell.viewWithTag(10) as? UIButton{
            delBtn.setTitle("", for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190.0
    }
    
    
}
