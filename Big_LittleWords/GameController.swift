//
//  GameController.swift
//  Big_LittleWords
//
//  Created by Руслан Нургалиев on 30.09.2022.
//

import UIKit

class GameController: UIViewController {
    
    var firstPlayer = Player(name: "")
    var secondPlayer = Player(name: "")
    var bigWord = ""
    var beforeWords: [String] = []
    var isFirst = true
    
    @IBOutlet weak var bigWordLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var firstScoreLabel: UILabel!
    @IBOutlet weak var secondScoreLabel: UILabel!
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var quiteButton: UIButton!
    @IBOutlet weak var readyButton: UIButton!
    
    @IBOutlet weak var firstStack: UIStackView!
    @IBOutlet weak var secondStack: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setViews()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        addTapToDismissKeyboard()
    }
    

    //1. в слове должно быть больше 1 буквы
    //2. слово не должно быть составлено ранее
    //3. слово не должно быть исходным словом
   
    func validate() -> Bool {
        
        guard let word = wordTextField.text?.lowercased() else {
            showAlert(message: "Техническая ошибка")
            return false
        }
        
        guard word.count > 1 else {
            showAlert(message: "Cлишком короткое слово!")
            return false
        }
        
        guard !(beforeWords.contains(word)) else {
            showAlert(message: "Прояви фантазию! Это слово было составлено ранее!")
            return false
        }

        guard word != bigWord else {
            showAlert(message: "Думаешь что ты самый умный? Прояви фантазию!")
            return false
        }
        
        guard word.count <= bigWord.count else {
            showAlert(message: "Подозрительно длинное слово! Как тебе это удалось?")
            return false
        }
        return true
    }
    
    func wordToChars(word: String) -> [Character] {
        
        var chars = [Character]()
        for char in word.lowercased() {
            chars.append(char)
        }
        return chars
    }
    
    func checkWord() -> Int {
        
        guard self.validate() else {
            return 0
        }
        
        guard let word = wordTextField.text?.lowercased() else {
            return 0
        }
        var resultWord = ""
        var bigChars = wordToChars(word: bigWord)
        let smallChars = wordToChars(word: word)
        
        for char in smallChars {
            if bigChars.contains(char) {
                resultWord.append(char)
                var i = 0
                while bigChars[i] != char {
                    i += 1
                }
                bigChars.remove(at: i)
            } else {
                showAlert(message: "Нельзя из слова \(bigWord) составить слово \(word)")
                return 0
            }
        }
        beforeWords.append(word)
        return word.count
    }
    
    func setViews() {
        let views: [UIView] = [firstNameLabel,
                               secondNameLabel,
                               wordTextField,
                               quiteButton,
                               readyButton,
                               tableView]
        for view in views {
            view.layer.cornerRadius = 23
           
            if view is UITextField {
                (view as! UITextField).leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
                (view as! UITextField).leftViewMode = .always
            }
        }
    }
    
    func updateInterface() {
        firstScoreLabel.text = "\(firstPlayer.score)"
        secondScoreLabel.text = "\(secondPlayer.score)"
        
        if isFirst {
            firstStack.layer.shadowOpacity = 0.8
            secondStack.layer.shadowOpacity = 0
        } else {
            firstStack.layer.shadowOpacity = 0
            secondStack.layer.shadowOpacity = 0.8
        }
        wordTextField.text?.removeAll()
        self.tableView.reloadData()
        
    }
    
    @IBAction func quitButtonTap(_ sender: UIButton) {
        let alert = UIAlertController(title: "Внимание", message: "Вы точно хотите закончить игру?", preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Да, хочу!", style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        let noAction = UIAlertAction(title: "Нет, давай играть!", style: .cancel)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true)
    }
    
    
    
    @IBAction func readyButtonTap(_ sender: UIButton) {
        let result = checkWord()
        if result > 0 {
            if isFirst {
                firstPlayer.score += result
            } else {
                secondPlayer.score += result
            }
            isFirst.toggle()
            updateInterface()
        }
    }
    
    
    func setupData() {
        self.bigWordLabel.text = bigWord
        self.firstNameLabel.text = firstPlayer.name
        self.secondNameLabel.text = secondPlayer.name
        self.firstScoreLabel.text = "\(0)"
        self.secondScoreLabel.text = "\(0)"
        firstStack.layer.shadowOpacity = 0.8
        secondStack.layer.shadowOpacity = 0
        firstStack.layer.shadowColor = UIColor.white.cgColor
        firstStack.layer.shadowRadius = 4
        firstStack.layer.shadowOffset = CGSize(width: 0, height: 0)
        secondStack.layer.shadowColor = UIColor.white.cgColor
        secondStack.layer.shadowRadius = 4
        secondStack.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
}

extension GameController: UITableViewDelegate, UITableViewDataSource {
  
    //количество ячеек в секциях таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beforeWords.count
    }
    
    //создает, заполняет и возвращает ячейку
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath) as! WordCell
        cell.wordLabel.text = beforeWords[indexPath.row]
        cell.scoreLabel.text = "\(beforeWords[indexPath.row].count)"
        
        return cell
    }
    
    
}
