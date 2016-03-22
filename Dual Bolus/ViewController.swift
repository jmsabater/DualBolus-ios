//
//  ViewController.swift
//  Dual Bolus
//
//  Created by Jose Maria Sabater on 19/3/16.
//  Copyright © 2016 Jose Maria Sabater. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: outlets
    @IBOutlet weak var HDCbuttonName: PushButtonView!
    @IBOutlet weak var FatbuttonName: PushButtonView!
    @IBOutlet weak var ProteinbuttonName: PushButtonView!
    
    @IBOutlet weak var uppercontainerView: UIView!
    @IBOutlet weak var upperView2: UIView!
    @IBOutlet weak var upperView1: UIView!
    @IBOutlet weak var changeUpperView: UIButton!
    
    @IBOutlet weak var horasBolus: UILabel!
    @IBOutlet weak var racionesLabel: UILabel!
    @IBOutlet weak var racionesInicio: UILabel!
    @IBOutlet weak var racionesSquare: UILabel!
    
    @IBOutlet weak var CarbohidratosTextField: UITextField!
    @IBOutlet weak var FatTextField: UITextField!
    @IBOutlet weak var ProteinTextField: UITextField!
    
    @IBOutlet weak var lowercontainerView: UIView!
    @IBOutlet weak var lowerView1: UIView!
    @IBOutlet weak var lowerView2: GraphView!
    
    //MARK: actions
    
    @IBAction func HDCButtonTouched(sender: PushButtonView) {
        HDCbuttonName.selected = true
        FatbuttonName.selected = false
        ProteinbuttonName.selected = false
        HDCbuttonName.alpha = 1.0
        FatbuttonName.alpha = 0.8
        ProteinbuttonName.alpha = 0.8

    }
    
    @IBAction func FatButtonTouched(sender: PushButtonView) {
        HDCbuttonName.selected = false
        FatbuttonName.selected = true
        ProteinbuttonName.selected = false
        HDCbuttonName.alpha = 0.8
        FatbuttonName.alpha = 1.0
        ProteinbuttonName.alpha = 0.8
    }
    
    @IBAction func ProteinButtonTouched(sender: PushButtonView) {
        HDCbuttonName.selected = false
        FatbuttonName.selected = false
        ProteinbuttonName.selected = true
        HDCbuttonName.alpha = 0.8
        FatbuttonName.alpha = 0.8
        ProteinbuttonName.alpha = 1.0

    }
    
    @IBAction func infoButtonPressed(sender: UIButton) {
        showAlertWithText("Información", message: "1.- Seleccione el nutriente. \n \n 2.- Deslice el dedo sobre el cuadro azul para variar las cantidades de nutrientes. \n \n 3.- La parte inferior muestra la configuración del bolo dual \n \n  Si desea introducir un valor numérico concreto, pulse 'Intr. valores ->' \n \n Si desea ver la gráfica del perfil del bolo dual configurado, pulse sobre la información del bolo ")
    }
     //MARK: Gesture actions
    @IBAction func upperView1PanUp(gesture:UIPanGestureRecognizer){
        let v = gesture.velocityInView(self.view )
        //print (v)
        let increment = Double(-v.y/1000.0)
        if (HDCbuttonName.selected == true){
            Carbohidrates += increment}
        else if (FatbuttonName.selected) == true {
            Fats += increment}
        else if (ProteinbuttonName.selected) == true {
            Proteins += increment}
        
        if (Carbohidrates <= 0){ Carbohidrates = 0.0}
        if (Fats <= 0){ Fats = 0.0}
        if (Proteins <= 0){ Proteins = 0.0}
        
        calcularUGP()
        refreshView()
        
    }
    
    @IBAction func ShowView2PushButton(sender: UIButton) {
        if (isUpperView2Showing){
            //volver a View1
            UIView.transitionFromView(upperView2, toView: upperView1, duration: 1.0, options: [.TransitionFlipFromLeft, .ShowHideTransitionViews], completion: nil)
            //y cambio el text del button
            changeUpperView.setTitle("Intr. valores ->", forState: .Normal)
            //y actualizo
            calcularUGP()
            refreshView()
        
            
        } else {
            //muestro View2
            UIView.transitionFromView(upperView1, toView: upperView2, duration: 1.0, options: [.TransitionFlipFromRight, .ShowHideTransitionViews], completion: nil)
            // y cambio el text del button
            changeUpperView.setTitle("<- volver", forState: .Normal)
            
        }
        isUpperView2Showing = !isUpperView2Showing
    }
    
    
    @IBAction func lowerViewTap(sender: UITapGestureRecognizer) {
        if (isLowerView2Showing){
            //volver a View1
            UIView.transitionFromView(lowerView2, toView: lowerView1, duration: 1.0, options: [.TransitionFlipFromLeft, .ShowHideTransitionViews], completion: nil)
        } else {
            //Paso los datos necesarios para construir el grafico
            lowerView2.obtenDatos (RacInicio, RacCuadrado: RacSquare, Raciones: Raciones)
            //fuerzo a redibujar el grafico con los nuevos datos
            lowerView2.setNeedsDisplay()
            //muestro View2
            UIView.transitionFromView(lowerView1, toView: lowerView2, duration: 1.0, options: [.TransitionFlipFromRight, .ShowHideTransitionViews], completion: nil)
        }
        isLowerView2Showing = !isLowerView2Showing
        
    }
    
    
    //MARK: properties
    var Carbohidrates:Double = 0.0
    var Fats = 0.0
    var Proteins = 0.0
    
    var isUpperView2Showing = false
    var isLowerView2Showing = false
    
    var Raciones:Double = 0.0
    var RacInicio:Double = 0.0
    var RacSquare:Double = 0.0
    
    let FatToKcal = 9.0
    let ProteinToKcal = 4.0
    let KcalToRac = 150.0
    let CarbohidratesToRac = 10.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Para manejar los textfield
        CarbohidratosTextField.delegate  = self
        FatTextField.delegate = self
        ProteinTextField.delegate = self
        
        isUpperView2Showing = false
        
        refreshView()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func CarbohidratesEndEditing(sender: UITextField) {
        Carbohidrates = Double(sender.text!)!
    }
    
    @IBAction func ProteinEndEditing(sender: UITextField) {
        Proteins = Double(sender.text!)!
    }
    @IBAction func FatEndEditing(sender: UITextField) {
        Fats = Double(sender.text!)!
    }
    
    //MARK: metodos
    func refreshView() ->(){
        
        let hdcTitle = String(format:"%.1f gr.", Carbohidrates)
        let fatTitle = String(format:"%.1f gr.", Fats)
        let proteinTitle = String(format:"%.1f gr.", Proteins)
        
        HDCbuttonName.setTitle(hdcTitle, forState: UIControlState.Normal)
        FatbuttonName.setTitle(fatTitle, forState: UIControlState.Normal)
        ProteinbuttonName.setTitle(proteinTitle, forState: UIControlState.Normal)
        
        //racionesLabel.text = "\(Raciones)"
        racionesLabel.text = String(format: "%.1f", Raciones)
        racionesInicio.text = String(format: "%.0f", RacInicio)
        racionesSquare.text = String(format: "%.0f", RacSquare)
        
        
        //upperview2
        CarbohidratosTextField.text = String(format: "%.1f",Carbohidrates)
        FatTextField.text = String(format: "%.1f",Fats)
        ProteinTextField.text = String(format: "%.1f",Proteins)
        
        //horas del cuadrado
        let UGPrac = round(RacSquare * 0.01 * Raciones)
        switch UGPrac {
        case 0:
            horasBolus.text = "--"
        case 0...1:
            horasBolus.text = "3 horas"
        case 1...2:
            horasBolus.text = "4 horas"
        case 2...3:
            horasBolus.text = "5 horas"
        case 3...4:
            horasBolus.text = "5 horas"
        case 4...5:
            horasBolus.text = "7 horas"
        default:
            horasBolus.text = "---"
            //TiempoSquare.textColor = UIColor.redColor()
        }

        
        
    }
    
    /*func getValues()-> Double {
        return RacInicio
    }*/
    
    func calcularUGP() ->(){
        Raciones = 0.0
        RacInicio = 0.0
        RacSquare = 0.0
        
        let racionesHDC = Carbohidrates/CarbohidratesToRac
        let racionesFat = (Fats * FatToKcal)/KcalToRac
        let racionesProteinas = (Proteins * ProteinToKcal )/KcalToRac
        
        Raciones = racionesHDC + racionesFat + racionesProteinas
        //print(Carbohidrates, Raciones)
        
        RacInicio = (racionesHDC/Raciones)*100
        RacSquare = ((racionesFat+racionesProteinas)/Raciones)*100
        //print("raciones:", Raciones, "RacInicio", RacInicio, "RacSquare", RacSquare)
        
        
    }
    
    // Show alert
    func showAlertWithText (header : String = "Instrucciones", message : String) {
        let alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        alert.view.tintColor = UIColor.blueColor()
        self.presentViewController(alert, animated: true, completion: nil)
    }


}

