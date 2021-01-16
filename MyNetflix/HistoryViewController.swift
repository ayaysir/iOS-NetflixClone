//
//  HistoryViewController.swift
//  MyNetflix
//
//  Created by yoonbumtae on 2021/01/16.
//  Copyright © 2021 com.joonwon. All rights reserved.
//

import UIKit
import Firebase

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var searchTerms: [SearchTerm] = []
    
    let db = Database.database().reference().child("searchHistory")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        db.observeSingleEvent(of: .value) {
            snapshot in
            guard let searchHistory = snapshot.value as? [String: Any] else { return }
        
            let data = try! JSONSerialization.data(withJSONObject: Array(searchHistory.values), options: [])
            
            let decoder = JSONDecoder()
            let searchTerms = try! decoder.decode([SearchTerm].self, from: data)
            print(searchTerms)
            self.searchTerms = searchTerms.sorted { term1, term2 in
                // 왼쪽에 있을수록 타임스탬프가 큼 (내림차순)
                return term1.timestamp > term2.timestamp
            }
            
            self.tableView.reloadData()
            
        }
    }

}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTerms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell else {
            return UITableViewCell()
        }
        cell.searchTerm.text = searchTerms[indexPath.row].term
        
        // 날짜 표기
        let date = NSDate(timeIntervalSince1970: searchTerms[indexPath.row].timestamp)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko") // 로케일 변경
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.date.text = formatter.string(from: date as Date)
        
        return cell
    }
    
    
}

class HistoryCell: UITableViewCell {
    @IBOutlet weak var searchTerm: UILabel!
    @IBOutlet weak var date: UILabel!
    
    
}

struct SearchTerm: Codable {
    let term: String
    let timestamp: TimeInterval
}
