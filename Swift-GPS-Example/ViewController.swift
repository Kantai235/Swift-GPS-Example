//
//  ViewController.swift
//  Swift-GPS-Example
//
//  Created by 乾太 on 2016/10/21.
//  Copyright © 2016年 乾太. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    // 地圖元件
    @IBOutlet weak var _mapView: MKMapView!
    
    // 座標管理元件
    var _locationManager : CLLocationManager!
    
    // NSLocationWhenInUseUsageDescription
    // 說明為何要取得使用 App 期間授權的文字
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        // 生成 CLLocationManager 這物件
        _locationManager = CLLocationManager()
        // 指定其代理 delegate
        _locationManager.delegate = self
        
        /*  設定定位精準度 locationManager.desiredAccuracy
         *      kCLLocationAccuracyBestForNavigation：精確度最高，適用於導航的定位。
         *      kCLLocationAccuracyBest：精確度高。
         *      kCLLocationAccuracyNearestTenMeters：精確度 10 公尺以內。
         *      kCLLocationAccuracyHundredMeters：精確度 100 公尺以內。
         *      kCLLocationAccuracyKilometer：精確度 1 公里以內。
         *      kCLLocationAccuracyThreeKilometers：精確度 3 公里以內。
         */
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        /* 如果要調用 requestAlwaysAuthorization() 這個方法
         * 你必須在 Info.plist 當中加入 NSLocationAlwaysUsageDescription 這個 Key&Value
         * 說明為何要取得永遠授權的文字，這樣才能調用這個方法來取得 GPS 權限。
         */
        _locationManager.requestAlwaysAuthorization()
        
        /* 如果要調用 requestWhenInUseAuthorization() 這個方法
         * 你必須在 Info.plist 當中加入 NSLocationWhenInUseUsageDescription 這個 Key&Value
         * 說明為何要取得使用 App 期間授權的文字，這樣才能調用這個方法來取得 GPS 權限。
         */
        _locationManager.requestWhenInUseAuthorization()
        
        // 表示移動 10 公尺再更新座標資訊
        _locationManager.distanceFilter = CLLocationDistance(10)
        // 開始接收目前位置資訊
        _locationManager.startUpdatingLocation()
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        // 因為 GPS 功能很耗電,所以背景執行時關閉定位功能
        _locationManager.stopUpdatingLocation();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //取得目前的座標位置
        let curLocation = locations[0] as! CLLocation
        // curLocation.coordinate.latitude 目前緯度
        // curLocation.coordinate.longitude 目前經度
        let nowLocation = CLLocationCoordinate2D(latitude: curLocation.coordinate.latitude, longitude: curLocation.coordinate.longitude)
        
        // 將 map 中心點定在目前所在的位置
        // span 是地圖 zoom in, zoom out 的級距
        let _span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
        self._mapView.setRegion(MKCoordinateRegion(center: nowLocation, span: _span), animated: true)
        
        print("latitude = \(curLocation.coordinate.latitude)")
        print("longitude = \(curLocation.coordinate.longitude)")
    }

    private func reverseGeocodeLocation(_latitude: Double, _longitude: Double) -> Void {
        let geoCoder = CLGeocoder()
        let currentLocation = CLLocation(
            latitude: _latitude,
            longitude: _longitude
        )
        geoCoder.reverseGeocodeLocation(
            currentLocation, completionHandler: {
                (placemarks, error) -> Void in
                if error != nil {
                    // 這邊可以加入一些你的 Try Error 機制
                    return
                }
            // name         街道地址
            // country      國家
            // province     省
            // locality     市
            // sublocality  縣.區
            // route        街道、路
            // streetNumber 門牌號碼
            // postalCode   郵遞區號
                if placemarks != nil && (placemarks?.count)! > 0{
                    let placemark = (placemarks?[0])! as CLPlacemark
                    //這邊拼湊轉回來的地址
                }
            }
        )
    }
    
}

