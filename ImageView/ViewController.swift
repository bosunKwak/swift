//
//  ViewController.swift
//  ImageView
//
//  Created by 곽보선 on 2021/07/22.
//

import UIKit

class ViewController: UIViewController {
    
    var isZoom = false  //isZoom: 확대 여부를 나타내는 변수
    var img:UIImage?    //img : 이미지가 있는 UIImage 타입의 변수
    @IBOutlet weak var imgView: UIImageView!
    @IBAction func btnResize(_ sender: UIButton) {
        
        let scale:CGFloat = 2.0 //2배
        var newWidth:CGFloat, newHeight:CGFloat  //확대할 크기 계산해서
        
        if(isZoom){ //true
            newWidth = imgView.frame.width/scale
            newHeight = imgView.frame.height/scale
            imgView.frame.size = CGSize(width: newWidth, height: newHeight)
            
        }
        else{   //false
            newWidth = imgView.frame.width*scale
            newHeight = imgView.frame.height*scale
            imgView.frame.size = CGSize(width: newWidth, height: newHeight)
            
        }
        
        isZoom = !isZoom
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        img = UIImage(named: "짱구.jpeg")
        imgView.image = img
        
    }


}

