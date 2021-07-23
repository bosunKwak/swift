//
//  ViewController.swift
//  Map
//
//  Created by 곽보선 on 2021/07/23.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var lblLocationInfo1: UILabel!
    @IBOutlet weak var lblLocationInfo2: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 위치 정보를 표시할 레이블에는 아직 특별히 표시할 필요가 없으므로 공백
        lblLocationInfo1.text = ""
        lblLocationInfo2.text = ""
        
        //상수 locationManger의 deligate를 self로 설정
        locationManager.delegate = self
        
        //정확도 최고로 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //위치 데이터를 추적하기 위해 사용자에게 승인 요구
        locationManager.requestWhenInUseAuthorization()

        //위치 업데이트 시작
        locationManager.startUpdatingLocation()
        
        //위치 보기 값을 true로 설정
        myMap.showsUserLocation = true
        
    }
    
    //위도와 경도, 영역 폭(span)을 입력받아 지도에 표시하는 함수
    func goLocation(latitude latitudeValue: CLLocationDegrees, longitude longitudeValue: CLLocationDegrees, delta span :Double)->CLLocationCoordinate2D{
        
        //위도 값과 경도 값을 매개변수로 하여 아래 함수를 호출하고 리턴 값을 pLocation으로 받음
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        
        //범위값을 매개변수로 아래 함수를 호출하고 리턴값을 spanValue로 받음
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        
        //pLocation과 spanValue값을 매개변수로 하여 아래 함수를 호출하고 리턴값을 pRegion으로 받음
        let pRegion = MKCoordinateRegion(center: pLocation,span: spanValue)
        
        //pRegion값을 매개변수로 하여 아래 함수 호출
        myMap.setRegion(pRegion, animated: true)
        
        return pLocation
    }
    
    //특정 위도와 경도에 핀 설치, 핀에 타이틀과 서브타이틀의 문자열 표시하는 함수
    func setAnnotation(latitude latitudeValue : CLLocationDegrees, longitude longitudeValue : CLLocationDegrees, delta span : Double, title strTitle: String, subtitle strSubtitle:String){
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latitude: latitudeValue, longitude: longitudeValue, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubtitle
        myMap.addAnnotation(annotation)
    }
    
    //위치 정보에서 국가, 지역, 도로를 추출하여 레이블에 표시해주는 함수
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //위치가 업데이트 되면 마지막 위치 찾음
        let pLocation = locations.last
        
        //마지막 위치의 위도와 경도값을 가지고 goLocation함수 호출
        //delta : 지도의 크기, 값이 작을수록 확대
        goLocation(latitude: (pLocation?.coordinate.latitude)!, longitude: (pLocation?.coordinate.longitude)!, delta: 0.01)
        
        //위치 정보 추출해 텍스트로 표기
        CLGeocoder().reverseGeocodeLocation(pLocation!, completionHandler: {
            
            (placemarks,error)->Void in
            let pm = placemarks!.first
            let country = pm!.country
            var address:String = country!
            
            if pm!.locality != nil{
                address += " "
                address += pm!.locality!
            }
            
            if pm!.thoroughfare != nil{
                address += " "
                address += pm!.thoroughfare!
            }
            
            self.lblLocationInfo1.text = "현재 위치"
            self.lblLocationInfo2.text = address
            
        })
        
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func sgChangeLocation(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            //현재 위치
            self.lblLocationInfo1.text = ""
            self.lblLocationInfo2.text = ""
            locationManager.startUpdatingLocation()
        }
        else if sender.selectedSegmentIndex == 1{
            //집
            setAnnotation(latitude: 37.36253531365121, longitude: 127.10506110970951, delta: 1, title: "정자 3차 푸르지오시티", subtitle: "경기도 성남시 정자일로 135")
            self.lblLocationInfo1.text = "보고 계신 위치"
            self.lblLocationInfo2.text = "정자 3차 푸르지오시티"
        }
        else if sender.selectedSegmentIndex == 2{
            //학교
            setAnnotation(latitude: 37.321637, longitude: 127.127128, delta: 0.1, title: "단국대학교", subtitle: "경기도 용인시 수지구 죽전1동 산44-1")
            self.lblLocationInfo1.text = "보고 계신 위치"
            self.lblLocationInfo2.text = "단국대학교"
        }
       }

}

