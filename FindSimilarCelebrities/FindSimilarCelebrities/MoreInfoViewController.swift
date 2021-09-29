//
//  MoreInfoViewController.swift
//  FindSimilarCelebrities
//
//  Created by 유준용 on 2021/09/27.
//

import UIKit

class MoreInfoViewController: UIViewController {
    let arr = [["",""],
        ["피드백 보내기","hellgey777@naver.com"],
        ["도움말",""],
        ["리뷰 남기기",""],
        ["version", "1.0.0"]
    ]
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.

    }
}
extension MoreInfoViewController: UITableViewDelegate{
    
}
extension MoreInfoViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") else{return UITableViewCell()}
        cell.accessoryType = .none
        var content = cell.defaultContentConfiguration()
        content.text = arr[indexPath.row][0]
        content.secondaryText = arr[indexPath.row][1]
        
        cell.contentConfiguration = content

        return cell
    }
    
    
}
