//
//  RequestViewController.swift
//  Vstu
//
//  Created by Roman Efimov on 20.02.17.
//  Copyright © 2017 Roman Efimov. All rights reserved.
//

import UIKit


class RequestViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {
    @IBOutlet weak var TypePicker: UIPickerView!
    
    @IBOutlet weak var SubjectPicker: UIPickerView!
    
    
    var Listepisodes = [[episodes]]()
    
    let headerTitles = ["Альтернативный", "Анидаб"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.TypePicker.delegate = self
        self.TypePicker.dataSource = self
        
        self.SubjectPicker.delegate = self
        self.SubjectPicker.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if pickerView == TypePicker
        {
            return headerTitles.count
        }
        
        
        if(self.TypePicker.selectedRow(inComponent: component) == 0){
            return (Listepisodes.first?.count)!
        }
        
        return (Listepisodes.last?.count)!
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == TypePicker
        {
            
            return headerTitles[row]
        }
        
        if(self.TypePicker.selectedRow(inComponent: component) == 0){
            return Listepisodes.first?[row].Name
        }
        return Listepisodes.last?[row].Name

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == TypePicker
        {
            self.SubjectPicker.reloadAllComponents()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
