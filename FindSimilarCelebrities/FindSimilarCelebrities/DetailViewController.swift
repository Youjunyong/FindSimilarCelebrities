//
//  DetailViewController.swift
//  FindSimilarCelebrities
//
//  Created by 유준용 on 2021/09/25.
//

import UIKit

class DetailViewController: UIViewController {

    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }


}

extension DetailViewController: UITableViewDelegate{
    
}
extension DetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else{return UITableViewCell()}
        if let label = cell.viewWithTag(2) as? UILabel{
            label.text = "내용 아직 없음"
        }
        if let icon = cell.viewWithTag(1) as? UIImageView{
            icon.image = UIImage(named: "IconRadioButton")
        }
        return cell
    }
    
    
}
