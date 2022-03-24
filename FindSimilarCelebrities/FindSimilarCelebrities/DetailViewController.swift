//
//  DetailViewController.swift
//  FindSimilarCelebrities
//
//  Created by 유준용 on 2021/09/25.
//

import UIKit

class DetailViewController: UIViewController {

    var dataIdx: Int?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    func setupDataString(_ dataSet: [Record], indexPathRow: Int )-> [String]{
        let data = dataSet[dataIdx!]
        let dataString = [
            ["닮은 유명인: \(data.celebrityValue!)",
             "신뢰도: \(data.celebrityConfidence!)"],
            ["예상 나이: \(data.faceAgeValue!)",
             "신뢰도: \(data.faceAgeConfidence!)"],
            ["분석 감정: \(data.faceEmotionValue!)",
            "신뢰도: \(data.faceEmotionConfidence!)"],
            ["성별: \(data.faceGenderValue!)",
             "신뢰도: \(data.faceGenderConfidence!)"],
            ["포즈: \(data.facePoseValue!)",
             "신뢰도: \(data.facePoseConfidence!)"]
        ]
        return dataString[indexPathRow]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        DataManager.shared.fetchRecord()
        imageView.image =  UIImage(data : DataManager.shared.recordList[dataIdx!].image!)
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
        let content = setupDataString( DataManager.shared.recordList, indexPathRow: indexPath.row)
        if let label = cell.viewWithTag(2) as? UILabel{
            label.text = content[0]
        }
        if let label2 = cell.viewWithTag(3) as? UILabel{
            label2.text = content[1]
        }
        if let icon = cell.viewWithTag(1) as? UIImageView{
            if indexPath.row != 0 {
                icon.image = UIImage(named: "IconRadioButton")
            }
        }
        return cell
    }
    
}
