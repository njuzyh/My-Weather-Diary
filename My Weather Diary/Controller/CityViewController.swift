//
//  CityViewController.swift
//  My Weather Diary
//
//  Created by zyh on 2018/12/2.
//  Copyright © 2018 njuzyh. All rights reserved.
//

import UIKit

struct City {
    let state : String
    let name : String
}

private let normalCityCell = "normalCityCell"
private let hotCityCell = "hotCityCell"
private let recentCityCell = "rencentCityCell"
private let currentCityCell = "currentCityCell"

class CityViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var searchCity: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityResults: UITableView!
    
    
    //获取城市数据
    lazy var cityDic:[String:[String]] = {
        let path = Bundle.main.path(forResource: "city", ofType: "plist")
        let dic = NSDictionary(contentsOfFile: path!)
        return dic as! [String : [String]]
    }()
    
    //热门城市数据
    lazy var hotCities:[String] = {
        let path = Bundle.main.path(forResource: "HotCity", ofType: "plist")
        let array = NSArray(contentsOfFile: path!)
        return array as! [String]
    }()
    
    //标题数组
    lazy var titleArray:[String] = {
        var array = [String]()
        for str in self.cityDic.keys {
            array.append(str)
        }
        array.sort()
        array.insert("热门", at: 0)
        array.insert("最近", at: 0)
        array.insert("定位", at: 0)
        return array
    }()
    
    var filteredCities = ["Beijing", "ShangHai", "Nanjing", "GuangZhou", "HangZhou"]
    var cities = [String]()
    //var cityResult : CityResultController = CityResultController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Setup the Search Controller
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.cityResults.delegate = self
        self.cityResults.dataSource = self
        self.searchCity.delegate = self
        self.searchCity.placeholder = "请输入城市名"
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.cityResults.register(UITableViewCell.self, forCellReuseIdentifier: normalCityCell)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: normalCityCell)
        self.tableView.register(CurrentCityTableViewCell.self, forCellReuseIdentifier: currentCityCell)
        self.tableView.register(RecentCityTableViewCell.self, forCellReuseIdentifier: recentCityCell)
        self.tableView.register(HotCityTableViewCell.self, forCellReuseIdentifier: hotCityCell)
        // 右边索引
        self.tableView.sectionIndexColor = mainColor
        self.tableView.sectionIndexBackgroundColor = UIColor.clear
        self.cityResults.isHidden = true
        self.tableView.isHidden = false
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.tableView == tableView {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: currentCityCell, for: indexPath) as! CurrentCityTableViewCell
                //cell.currentCity = locateCity
                cell.callBack = { [weak self] in
                    self?.navigationController?.pushViewController(CenterViewController(), animated: true)
                }
                return cell
            }else if indexPath.section == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: recentCityCell, for: indexPath) as! RecentCityTableViewCell
                // 点击最近城市按钮调用此闭包
                cell.callBack = { [weak self] (btn) in
                    // 请求数据
                    //NetworkManager.weatherData(cityName: btn.titleLabel?.text ?? "")
                    self?.navigationController?.pushViewController(CenterViewController(), animated: true)
                }
                return cell
            }else if indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: hotCityCell, for: indexPath) as! HotCityTableViewCell
                cell.callBack = { [weak self] (btn) in
                    // 请求数据
                    //NetworkManager.weatherData(cityName: btn.titleLabel?.text ?? "")
                    self?.navigationController?.pushViewController(CenterViewController(), animated: true)
                }
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: normalCityCell, for: indexPath)
                let key = titleArray[indexPath.section]
                cell.textLabel?.text = cityDic[key]![indexPath.row]
                return cell
            }
        }
        else
        {
            //print(cities.count)
            //print(indexPath.row)
            let cell = tableView.dequeueReusableCell(withIdentifier: normalCityCell, for: indexPath)
            if cities.count > indexPath.row{
                cell.textLabel?.text = cities[indexPath.row]
            }
            return cell
        }
    }
    
    // MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.tableView == tableView{
            tableView.deselectRow(at: indexPath, animated: false)
            let cell = tableView.cellForRow(at: indexPath)
            print("点击了 \(cell?.textLabel?.text ?? "")")
            if indexPath.section > 2 {
                /// 请求数据
                //NetworkManager.weatherData(cityName: cell?.textLabel?.text ?? "")
                //self.navigationController?.pushViewController(CenterViewController(), animated: true)
            }else {
                return
            }
        }
    }
    
    // MARK: 右边索引
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if self.tableView == tableView{
            return titleArray
        }
        return nil
    }
    
    // MARK: section头视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.tableView == tableView{
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: sectionMargin))
            let title = UILabel(frame: CGRect(x: 15, y: 5, width: 375 - 15, height: 28))
            var titleArr = titleArray
            titleArr[0] = "当前定位城市"
            titleArr[1] = "最近选择城市"
            titleArr[2] = "热门城市"
            title.text = titleArr[section]
            title.textColor = mainColor
            title.font = UIFont.boldSystemFont(ofSize: 18)
            view.addSubview(title)
            view.backgroundColor = UIColor.white
            if section > 2 {
                view.backgroundColor = mainColor
                title.textColor = UIColor.white
            }
            return view
        }
        return nil
    }
    
    // MARK: row高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.tableView == tableView{
            if indexPath.section == 0 {
                return btnHeight + 2 * btnMargin
            }else if indexPath.section == 1 {
                return btnHeight + 2 * btnMargin
            }else if indexPath.section == 2 {
                let row = (hotCities.count - 1) / 3
                return (btnHeight + 2 * btnMargin) + (btnMargin + btnHeight) * CGFloat(row)
            }else{
                return 42
            }
        }
        return 42
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableView == tableView{
            return sectionMargin
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.tableView == tableView{
            return titleArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tableView == tableView{
            if section > 2 {
                let key = titleArray[section]
                return cityDic[key]!.count - 3
            }
            return 1
        }
        return cities.count
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var resultArray:[String] = []
        if searchText == "" {
            //cityResult.resultArray = resultArray
            //cityResult.tableView.reloadData()
            cities = resultArray
            self.cityResults.isHidden = false
            self.tableView.isHidden = true
            self.cityResults.reloadData()
            return
        }
        // 传递闭包 当点击’搜索结果‘的cell调用
        /*cityResult.callBack = { [weak self] in
            // 搜索完成 关闭resultVC
            print("guanbisousuo")
        }*/
        // 中文搜索
        if searchText.isIncludeChineseIn() {
            // 转拼音
            let pinyin = searchText.chineseToPinyin()
            // 获取大写首字母
            let first = String(pinyin[pinyin.startIndex]).uppercased()
            guard let dic = cityDic[first] else {
                return
            }
            for str in dic {
                if str.hasPrefix(searchText) {
                    resultArray.append(str)
                }
            }
            cities = resultArray
            for x in cities{
                print(x)
            }
            self.cityResults.isHidden = false
            self.tableView.isHidden = true
            self.cityResults.reloadData()
            //cityResult.resultArray = resultArray
            //cityResult.tableView.reloadData()
        }else {
            // 拼音搜索
            // 若字符个数为1
            if searchText.count == 1 {
                guard let dic = cityDic[searchText.uppercased()] else {
                    return
                }
                resultArray = dic
                cities = resultArray
                self.cityResults.isHidden = false
                self.tableView.isHidden = true
                self.cityResults.reloadData()
                //cityResult.resultArray = resultArray
                //cityResult.tableView.reloadData()
            }else {
                guard let dic = cityDic[searchText.first().uppercased()] else {
                    return
                }
                for str in dic {
                    // 去空格
                    let py = String(str.chineseToPinyin().filter({ $0 != " "}))
                    let range = py.range(of: searchText)
                    if range != nil {
                        resultArray.append(str)
                    }
                }
                // 加入首字母判断 如 cq => 重庆 bj => 北京
                if resultArray.count == 0 {
                    for str in dic {
                        // 北京 => bei jing
                        let pinyin = str.chineseToPinyin()
                        // 获取空格的index
                        let a = pinyin.index(of: " ")
                        let index = pinyin.index(a!, offsetBy: 2)
                        // offsetBy: 2 截取 bei j
                        // offsetBy: 1 截取 bei+空格
                        // substring(to: index) 不包含 index最后那个下标
                        let py = String(pinyin[..<index])
                        /// 获取第二个首字母
                        ///
                        ///     py = "bei j"
                        ///     last = "j"
                        ///
                        let last = String(py[py.index(py.endIndex, offsetBy: -1)...])
                        /// 两个首字母
                        let pyIndex = String(pinyin[pinyin.startIndex]) + last
                        
                        if searchText.lowercased() == pyIndex {
                            resultArray.append(str)
                        }
                    }
                }
                cities = resultArray
                self.cityResults.isHidden = false
                self.tableView.isHidden = true
                self.cityResults.reloadData()
                //cityResult.resultArray = resultArray
                //cityResult.tableView.reloadData()
            }
        }
        /*if (searchText == "")
        {
            self.cities = self.filteredCities
        }
        else
        {
            self.cities = []
            for arr in self.filteredCities
            {
                if(arr.lowercased().contains(searchText.lowercased()))
                {
                    self.cities.append(arr)
                }
            }
        }
        self.tableView.reloadData()*/
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.cities.removeAll()
        self.cityResults.isHidden = true
        self.tableView.isHidden = false
        //self.tableView.reloadData()
        //self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
}
