import Cocoa

class ViewController: NSViewController {
    
    // Основные элементы
    let textView = NSTextView()
    let scrollView = NSScrollView()
    let formatToolbar = NSView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWindow()
        setupToolbar()
        setupTextView()
    }
    
    func setupWindow() {
        // Настраиваем главное окно
        view.frame = CGRect(x: 0, y: 0, width: 800, height: 600)
    }
    
    func setupToolbar() {
        // Панель форматирования
        formatToolbar.frame = CGRect(x: 0, y: 560, width: 800, height: 40)
        formatToolbar.wantsLayer = true
        formatToolbar.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
        
        // Кнопки форматирования
        let boldButton = NSButton(title: "Ж", target: self, action: #selector(toggleBold(_:)))
        boldButton.frame = CGRect(x: 10, y: 5, width: 30, height: 30)
        formatToolbar.addSubview(boldButton)
        
        let italicButton = NSButton(title: "К", target: self, action: #selector(toggleItalic(_:)))
        italicButton.frame = CGRect(x: 50, y: 5, width: 30, height: 30)
        formatToolbar.addSubview(italicButton)
        
        // Кнопки файлов
        let saveButton = NSButton(title: "Сохранить", target: self, action: #selector(saveDocument(_:)))
        saveButton.frame = CGRect(x: 700, y: 5, width: 80, height: 30)
        formatToolbar.addSubview(saveButton)
        
        view.addSubview(formatToolbar)
    }
    
    func setupTextView() {
        // Текстовое поле на все окно
        scrollView.frame = CGRect(x: 0, y: 0, width: 800, height: 560)
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        
        textView.frame = scrollView.bounds
        textView.minSize = NSSize(width: 800, height: 560)
        textView.maxSize = NSSize(width: 10000, height: 10000)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = true
        textView.autoresizingMask = [.width, .height]
        
        textView.font = NSFont.systemFont(ofSize: 14)
        textView.string = "Добро пожаловать в текстовый редактор!\n\nНачните писать здесь..."
        textView.isEditable = true
        textView.isRichText = true // Включаем форматирование
        
        scrollView.documentView = textView
        view.addSubview(scrollView)
    }
    
    // Действия форматирования
    @objc func toggleBold(_ sender: Any) {
        textView.toggleRuler(nil)
    }
    
    @objc func toggleItalic(_ sender: Any) {
        // Пока заглушка
        print("Курсив")
    }
    
    @objc func saveDocument(_ sender: Any) {
        let savePanel = NSSavePanel()
        savePanel.allowedFileTypes = ["rtf", "txt"]
        savePanel.nameFieldStringValue = "document.rtf"
        
        savePanel.begin { response in
            if response == .OK, let url = savePanel.url {
                if let rtfData = self.textView.rtf(from: self.textView.selectedRange) {
                    try? rtfData.write(to: url)
                }
            }
        }
    }
}

