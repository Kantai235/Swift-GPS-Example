# iOS Swift 地圖基本應用
### CLLocationManagerDelegate

#### 需要 import 的東西
```Swift
import MapKit
import CoreLocation
```

#### 委任對象 CLLocationManager().delegate 需要加入 CLLocationManagerDelegate 這個協定
```Swift
class ViewController: UIViewController, CLLocationManagerDelegate {
    // Code ...
}
```

#### 在全域變數加入座標管理元件
```Swiftf
var _locationManager : CLLocationManager!
```

#### 在 viewDidLoad() 要做的事情
```Swift
// 生成 CLLocationManager 這物件
_locationManager = CLLocationManager()
// 指定其代理 delegate 委任對象
_locationManager.delegate = self
```

#### 自身定位精準度、移動距離精準度
```Swift
/*  設置自身定位精準度 _locationManager.desiredAccuracy
 *  設置移動距離精準度 _locationManager.distanceFilter
 *      kCLLocationAccuracyBestForNavigation：精確度最高，適用於導航的定位。
 *      kCLLocationAccuracyBest：精確度高。
 *      kCLLocationAccuracyNearestTenMeters：精確度 10 公尺以內。
 *      kCLLocationAccuracyHundredMeters：精確度 100 公尺以內。
 *      kCLLocationAccuracyKilometer：精確度 1 公里以內。
 *      kCLLocationAccuracyThreeKilometers：精確度 3 公里以內。
 */
_locationManager.desiredAccuracy = kCLLocationAccuracyBest
_locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
```

#### requestAlwaysAuthorization
```Swift
/* 如果要調用 requestAlwaysAuthorization() 這個方法
 * 你必須在 Info.plist 當中加入 NSLocationAlwaysUsageDescription 這個 Key&Value
 * 說明為何要取得永遠授權的文字，這樣才能調用這個方法來取得 GPS 權限。
 */
_locationManager.requestAlwaysAuthorization()
```

#### requestWhenInUseAuthorization
```Swift
/* 如果要調用 requestWhenInUseAuthorization() 這個方法
 * 你必須在 Info.plist 當中加入 NSLocationWhenInUseUsageDescription 這個 Key&Value
 * 說明為何要取得使用 App 期間授權的文字，這樣才能調用這個方法來取得 GPS 權限。
 */
_locationManager.requestWhenInUseAuthorization()
```

#### 更新座標頻率
```Swift
// 表示移動 10 公尺再更新座標資訊
_locationManager.distanceFilter = CLLocationDistance(10)
```

#### 開始、結束
```Swift
// 開始接收目前位置資訊
_locationManager.startUpdatingLocation()
// 因為 GPS 功能很耗電，所以背景執行時關閉定位功能
_locationManager.stopUpdatingLocation();
```

#### 實作 CLLocationManagerDelegate 需要的委任方法
```Swift
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // 取得目前的座標位置
    let _curLocation = locations[0]
    
    // curLocation.coordinate.latitude 目前緯度
    // curLocation.coordinate.longitude 目前經度
    let _nowLocationCoordinate2D = CLLocationCoordinate2D(
        latitude: _curLocation.coordinate.latitude,
        longitude: _curLocation.coordinate.longitude
    )
    
    // _span 是地圖 zoom in, zoom out 的級距
    let _coordinateSpan: MKCoordinateSpan = MKCoordinateSpan(
        latitudeDelta: 0.005,
        longitudeDelta: 0.005
    )
    
    // 將地圖中心點座標定位在目前所在的位置上
    self._mapView.setRegion(
        MKCoordinateRegion(
            center: _nowLocationCoordinate2D,
            span: _coordinateSpan
        ),
        animated: true
    )
    
    NSLog("latitude = \(_curLocation.coordinate.latitude)")
    NSLog("longitude = \(_curLocation.coordinate.longitude)")
}
```

#### 將經緯度轉成地址的方法
```Swift
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
            /*  name            街道地址
             *  country         國家
             *  province        省籍
             *  locality        城市
             *  sublocality     縣市、區
             *  route           街道、路名
             *  streetNumber    門牌號碼
             *  postalCode      郵遞區號
             */
            if placemarks != nil && (placemarks?.count)! > 0{
                let placemark = (placemarks?[0])! as CLPlacemark
                //這邊拼湊轉回來的地址
            }
        }
    )
}
```

#### 在地圖上新增一個大頭針的方法
```Swift
private func addPointAnnotation(_latitude: CLLocationDegrees , _longitude: CLLocationDegrees) {
    // 建構一個大頭針元件 MKPointAnnotation()
    let _pointAnnotation: MKPointAnnotation = MKPointAnnotation();
    // 定義大頭針的經緯度座標
    _pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: _latitude, longitude: _longitude);
    // 定義大頭針顯示的標題
    _pointAnnotation.title = "大頭針標題";
    // 定義大頭針的內容訊息
    _pointAnnotation.subtitle = "緯度：\(_latitude) 經度:\(_longitude)";
    // 在地圖上新增大頭針座標
    self._mapView.addAnnotation(_pointAnnotation);
}
```