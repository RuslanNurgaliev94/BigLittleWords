//
//  ViewController.swift
//  Big_LittleWords
//
//  Created by Руслан Нургалиев on 29.09.2022.
//

import UIKit

class StartController: UIViewController {
    
    @IBOutlet weak var bigWordTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var secondNameTF: UITextField!
    @IBOutlet weak var startButton: UIButton!
    
    let picker = UIPickerView()
    let bigWords = [
        "Магнитотерапия",
        "Рекогносцировка",
        "Гиперинфляция",
        "Суперантисанитария",
        "Гипертоталитаризм"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        bigWordTF.inputView = picker
        self.picker.delegate = self
        self.picker.dataSource = self
        addTapToDismissKeyboard()
    }
    
    func setViews() {
        let views: [UIView] = [bigWordTF,
                               firstNameTF,
                               secondNameTF,
                               startButton]
        for view in views {
            view.layer.cornerRadius = 23
            
            if view is UITextField {
                (view as! UITextField).leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
                (view as! UITextField).leftViewMode = .always
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ToGameVC":
            let destVC = segue.destination as! GameController
            
            //1 создаются игроки
            var player1 = Player(name: "Игрок 1")
            var player2 = Player(name: "Игрок 2")
            if let name1 = firstNameTF.text, name1.count > 0 {
                player1.name = name1
            }
            if let name2 = secondNameTF.text, name2.count > 0 {
                player2.name = name2
            }
            
            guard let word = bigWordTF.text else {
                return
            }
            
            destVC.bigWord = word
            destVC.firstPlayer = player1
            destVC.secondPlayer = player2
            
        default: break
        }
    }

    @IBAction func startTapped(_ sender: UIButton) {
        
        //2 проверяется слово на предмет количества символов. Условие - символов должно быть больше 7
        guard let word = bigWordTF.text, word.count > 7 else {
            showAlert(message: "Слишком короткое длинное слово")
            return
        }
        
        //3 осуществляется переход на главный игровой экран. введенная информация должна передаваться на второй экран и размещаться в его интерфейсе
        performSegue(withIdentifier: "ToGameVC", sender: nil)
    }
}

extension StartController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    //количество компонентов в пикере
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //количество строк в компоненте
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bigWords.count
    }
    
    //Заголовки строк в пикере:
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return bigWords[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        bigWordTF.text = bigWords[row]
    }
}
