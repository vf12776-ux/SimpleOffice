import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var textView: NSTextView!
    var nuclearButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        // Создаем текстовое поле
        textView = NSTextView(frame: NSRect(x: 20, y: 60, width: 400, height: 300))
        textView.string = "Здесь ваш текст..."
        view.addSubview(textView)
        
        // Создаем кнопку "Нахер всё"
        nuclearButton = NSButton(title: "Нахер всё", target: self, action: #selector(nuclearOption))
        nuclearButton.frame = NSRect(x: 20, y: 20, width: 100, height: 30)
        nuclearButton.bezelStyle = .rounded
        view.addSubview(nuclearButton)
    }
    
    @objc func nuclearOption() {
        let alert = NSAlert()
        alert.messageText = "Подтверждение"
        alert.informativeText = "Точно нахер всё? Это действие нельзя отменить!"
        alert.addButton(withTitle: "Да")
        alert.addButton(withTitle: "Нет")
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            textView.string = ""
            // Можно добавить уведомление
            print("Текст ликвидирован! 💥")
        }
    }
}
