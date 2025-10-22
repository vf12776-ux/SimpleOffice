import Cocoa
import NaturalLanguage

class ViewController: NSViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var textView: NSTextView!
    private var nuclearButton: NSButton!
    private var pomodoroButton: NSButton!
    private var pomodoroLabel: NSTextField!
    private var saveButton: NSButton!
    private var loadButton: NSButton!
    private var exportPDFButton: NSButton!
    private var aiAssistantButton: NSButton!
    
    // MARK: - Pomodoro Timer
    private var pomodoroTimer: Timer?
    private var workTime: Int = 25 * 60
    private var breakTime: Int = 5 * 60
    private var isWorkSession: Bool = true
    private var timeRemaining: Int = 0
    
    // MARK: - Current File
    private var currentFileURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMenu()
    }
    
    private func setupUI() {
        setupTextView()
        setupNuclearButton()
        setupPomodoroSection()
        setupFileButtons()
        setupAIAssistantButton()
        setupTheming()
    }
    
    private func setupTextView() {
        textView.font = NSFont.systemFont(ofSize: 14)
        textView.string = "Добро пожаловать в SimpleOffice!\n\nНачните писать здесь..."
    }
    
    private func setupNuclearButton() {
        nuclearButton = NSButton(title: "💥 Нахер всё", target: self, action: #selector(nuclearOption))
        nuclearButton.frame = NSRect(x: 20, y: 20, width: 120, height: 30)
        nuclearButton.bezelStyle = .rounded
        nuclearButton.contentTintColor = .systemRed
        view.addSubview(nuclearButton)
    }
    
    private func setupPomodoroSection() {
        pomodoroButton = NSButton(title: "🍅 Старт", target: self, action: #selector(togglePomodoro))
        pomodoroButton.frame = NSRect(x: 160, y: 20, width: 100, height: 30)
        pomodoroButton.bezelStyle = .rounded
        view.addSubview(pomodoroButton)
        
        pomodoroLabel = NSTextField(labelWithString: "25:00")
        pomodoroLabel.frame = NSRect(x: 270, y: 20, width: 60, height: 30)
        pomodoroLabel.alignment = .center
        pomodoroLabel.font = NSFont.monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        view.addSubview(pomodoroLabel)
    }
    
    private func setupFileButtons() {
        saveButton = NSButton(title: "💾 Сохранить", target: self, action: #selector(saveDocument))
        saveButton.frame = NSRect(x: 350, y: 20, width: 100, height: 30)
        saveButton.bezelStyle = .rounded
        view.addSubview(saveButton)
        
        loadButton = NSButton(title: "📂 Открыть", target: self, action: #selector(loadDocument))
        loadButton.frame = NSRect(x: 460, y: 20, width: 100, height: 30)
        loadButton.bezelStyle = .rounded
        view.addSubview(loadButton)
        
        exportPDFButton = NSButton(title: "📄 PDF", target: self, action: #selector(exportToPDF))
        exportPDFButton.frame = NSRect(x: 570, y: 20, width: 80, height: 30)
        exportPDFButton.bezelStyle = .rounded
        view.addSubview(exportPDFButton)
    }
    
    private func setupAIAssistantButton() {
        aiAssistantButton = NSButton(title: "🧠 ИИ Помощник", target: self, action: #selector(showAIAssistant))
        aiAssistantButton.frame = NSRect(x: 660, y: 20, width: 120, height: 30)
        aiAssistantButton.bezelStyle = .rounded
        view.addSubview(aiAssistantButton)
    }
    
    // MARK: - Pomodoro Timer
    @objc private func togglePomodoro() {
        if pomodoroTimer == nil {
            startPomodoro()
        } else {
            stopPomodoro()
        }
    }
    
    private func startPomodoro() {
        timeRemaining = isWorkSession ? workTime : breakTime
        pomodoroTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        pomodoroButton.title = "⏸️ Пауза"
        updateTimerDisplay()
    }
    
    private func stopPomodoro() {
        pomodoroTimer?.invalidate()
        pomodoroTimer = nil
        pomodoroButton.title = "🍅 Старт"
    }
    
    @objc private func updateTimer() {
        timeRemaining -= 1
        updateTimerDisplay()
        
        if timeRemaining <= 0 {
            pomodoroTimer?.invalidate()
            pomodoroTimer = nil
            
            let sessionType = isWorkSession ? "Работа" : "Отдых"
            showNotification(title: "Pomodoro завершен!", message: "Сессия \(sessionType) закончена.")
            
            isWorkSession.toggle()
            pomodoroButton.title = "🍅 Старт"
        }
    }
    
    private func updateTimerDisplay() {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        pomodoroLabel.stringValue = String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - File Operations
    @objc private func saveDocument() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.plainText]
        panel.nameFieldStringValue = "document.txt"
        
        panel.begin { response in
            if response == .OK, let url = panel.url {
                do {
                    try self.textView.string.write(to: url, atomically: true, encoding: .utf8)
                    self.currentFileURL = url
                    self.showNotification(title: "Успех!", message: "Файл сохранен")
                } catch {
                    self.showAlert(title: "Ошибка", message: "Не удалось сохранить файл: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc private func loadDocument() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.plainText]
        
        panel.begin { response in
            if response == .OK, let url = panel.url {
                do {
                    let content = try String(contentsOf: url, encoding: .utf8)
                    self.textView.string = content
                    self.currentFileURL = url
                    self.showNotification(title: "Успех!", message: "Файл загружен")
                } catch {
                    self.showAlert(title: "Ошибка", message: "Не удалось загрузить файл: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc private func exportToPDF() {
        let printInfo = NSPrintInfo.shared
        let printOperation = NSPrintOperation(view: textView, printInfo: printInfo)
        printOperation.showsPrintPanel = false
        printOperation.showsProgressPanel = false
        
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.pdf]
        savePanel.nameFieldStringValue = "document.pdf"
        
        savePanel.begin { response in
            if response == .OK, let url = savePanel.url {
                printInfo.dictionary()[NSPrintInfo.AttributeKey.jobDisposition] = NSPrintInfo.JobDisposition.save
                printInfo.dictionary()[NSPrintInfo.AttributeKey.jobSavingURL] = url
                printOperation.run()
                self.showNotification(title: "Успех!", message: "PDF экспортирован")
            }
        }
    }
    
    // MARK: - AI Assistant
    @objc private func showAIAssistant() {
        let alert = NSAlert()
        alert.messageText = "🧠 ИИ Помощник"
        alert.informativeText = "Выберите действие:"
        
        alert.addButton(withTitle: "📊 Анализ текста")
        alert.addButton(withTitle: "✨ Улучшить текст")
        alert.addButton(withTitle: "➡️ Продолжить текст")
        alert.addButton(withTitle: "❌ Отмена")
        
        let response = alert.runModal()
        
        switch response {
        case .alertFirstButtonReturn:
            showTextAnalysis()
        case .alertSecondButtonReturn:
            improveText()
        case .alertThirdButtonReturn:
            continueText()
        default:
            break
        }
    }
    
    private func showTextAnalysis() {
        let analysis = AIAssistant.analyzeText(textView.string)
        
        let alert = NSAlert()
        alert.messageText = "📊 Анализ текста"
        alert.informativeText = """
        Слов: \(analysis["wordCount"] ?? 0)
        Символов: \(analysis["characterCount"] ?? 0)
        Абзацев: \(analysis["paragraphCount"] ?? 0)
        Настроение: \(analysis["sentiment"] ?? "Не определен")
        Время чтения: \(analysis["readingTime"] ?? "?")
        """
        alert.runModal()
    }
    
    private func improveText() {
        let improvedText = AIAssistant.improveText(textView.string)
        textView.string = improvedText
        showNotification(title: "Текст улучшен!", message: "ИИ применил магию ✨")
    }
    
    private func continueText() {
        let continuation = AIAssistant.continueText(textView.string)
        textView.string += "\n\n" + continuation
    }
    
    // MARK: - Nuclear Option
    @objc private func nuclearOption() {
        let alert = NSAlert()
        alert.messageText = "Подтверждение ликвидации"
        alert.informativeText = "Точно нахер всё? Это действие нельзя отменить!"
        alert.addButton(withTitle: "Да, нахер!")
        alert.addButton(withTitle: "Отмена")
        
        if alert.runModal() == .alertFirstButtonReturn {
            textView.string = ""
            showNotification(title: "Текст ликвидирован!", message: "💥 Начинайте с чистого листа!")
        }
    }
    
    // MARK: - Menu
    private func setupMenu() {
        let mainMenu = NSMenu()
        
        // File Menu
        let fileMenu = NSMenu(title: "Файл")
        let fileMenuItem = NSMenuItem(title: "Файл", action: nil, keyEquivalent: "")
        fileMenuItem.submenu = fileMenu
        mainMenu.addItem(fileMenuItem)
        
        fileMenu.addItem(NSMenuItem(title: "Сохранить", action: #selector(saveDocument), keyEquivalent: "s"))
        fileMenu.addItem(NSMenuItem(title: "Открыть", action: #selector(loadDocument), keyEquivalent: "o"))
        fileMenu.addItem(NSMenuItem(title: "Экспорт в PDF", action: #selector(exportToPDF), keyEquivalent: "e"))
        fileMenu.addItem(NSMenuItem.separator())
        fileMenu.addItem(NSMenuItem(title: "Выйти", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        // Edit Menu
        let editMenu = NSMenu(title: "Правка")
        let editMenuItem = NSMenuItem(title: "Правка", action: nil, keyEquivalent: "")
        editMenuItem.submenu = editMenu
        mainMenu.addItem(editMenuItem)
        
        editMenu.addItem(NSMenuItem(title: "Вырезать", action: #selector(NSText.cut(_:)), keyEquivalent: "x"))
        editMenu.addItem(NSMenuItem(title: "Копировать", action: #selector(NSText.copy(_:)), keyEquivalent: "c"))
        editMenu.addItem(NSMenuItem(title: "Вставить", action: #selector(NSText.paste(_:)), keyEquivalent: "v"))
        editMenu.addItem(NSMenuItem(title: "Выделить всё", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a"))
        
        // AI Menu
        let aiMenu = NSMenu(title: "ИИ Помощник")
        let aiMenuItem = NSMenuItem(title: "ИИ Помощник", action: nil, keyEquivalent: "")
        aiMenuItem.submenu = aiMenu
        mainMenu.addItem(aiMenuItem)
        
        aiMenu.addItem(NSMenuItem(title: "Анализ текста", action: #selector(showTextAnalysis), keyEquivalent: "l"))
        aiMenu.addItem(NSMenuItem(title: "Улучшить текст", action: #selector(improveText), keyEquivalent: "u"))
        aiMenu.addItem(NSMenuItem(title: "Продолжить текст", action: #selector(continueText), keyEquivalent: "y"))
        
        NSApp.mainMenu = mainMenu
    }
    
    // MARK: - Theming & Utilities
    private func setupTheming() {
        if #available(macOS 10.14, *) {
            view.window?.appearance = NSAppearance(named: .darkAqua)
        }
    }
    
    private func showNotification(title: String, message: String) {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = message
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.runModal()
    }
}

// MARK: - AI Assistant Implementation
class AIAssistant {
    static func analyzeText(_ text: String) -> [String: Any] {
        var analysis: [String: Any] = [:]
        
        // Word count
        let words = text.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        analysis["wordCount"] = words.count
        
        // Character count
        analysis["characterCount"] = text.count
        
        // Paragraph count
        let paragraphs = text.components(separatedBy: "\n").filter { !$0.isEmpty }
        analysis["paragraphCount"] = paragraphs.count
        
        // Reading time (approx)
        let readingTimeMinutes = Double(text.count) / 1000.0
        analysis["readingTime"] = "\(Int(readingTimeMinutes.rounded())) мин"
        
        // Basic sentiment analysis
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        let sentiment = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        
        if let sentimentScore = sentiment.0?.rawValue, let score = Double(sentimentScore) {
            switch score {
            case ..<0: analysis["sentiment"] = "😔 Негативный"
            case 0..<0.1: analysis["sentiment"] = "😐 Нейтральный"
            default: analysis["sentiment"] = "😊 Позитивный"
            }
        } else {
            analysis["sentiment"] = "🤔 Не определен"
        }
        
        return analysis
    }
    
    static func improveText(_ text: String) -> String {
        var improved = text
        
        // Remove extra spaces
        improved = improved.replacingOccurrences(of: " +", with: " ", options: .regularExpression)
        
        // Capitalize first letter of sentences
        let sentences = improved.components(separatedBy: ". ")
        improved = sentences.map { sentence in
            guard !sentence.isEmpty else { return sentence }
            return sentence.prefix(1).uppercased() + sentence.dropFirst()
        }.joined(separator: ". ")
        
        return improved
    }
    
    static func continueText(_ text: String) -> String {
        let continuations = [
            "Это открывает новые возможности для дальнейшего развития.",
            "Таким образом, мы можем сделать важные выводы.",
            "Этот подход демонстрирует свою эффективность на практике.",
            "Подобные решения заслуживают особого внимания.",
            "В результате мы получаем качественно новый уровень."
        ]
        
        return continuations.randomElement() ?? "Продолжение мысли..."
    }
}
