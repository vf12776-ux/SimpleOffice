import Cocoa

class ViewController: NSViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var textView: NSTextView!
    private var nuclearButton: NSButton!
    private var pomodoroButton: NSButton!
    private var pomodoroLabel: NSTextField!
    
    // MARK: - Pomodoro Timer
    private var pomodoroTimer: Timer?
    private var workTime: Int = 25 * 60 // 25 минут
    private var breakTime: Int = 5 * 60  // 5 минут
    private var isWorkSession: Bool = true
    private var timeRemaining: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupTextView()
        setupNuclearButton()
        setupPomodoroSection()
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
    
    // MARK: - Pomodoro Timer Implementation
    private func setupPomodoroSection() {
        // Кнопка Pomodoro
        pomodoroButton = NSButton(title: "🍅 Старт", target: self, action: #selector(togglePomodoro))
        pomodoroButton.frame = NSRect(x: 160, y: 20, width: 100, height: 30)
        pomodoroButton.bezelStyle = .rounded
        view.addSubview(pomodoroButton)
        
        // Метка таймера
        pomodoroLabel = NSTextField(labelWithString: "25:00")
        pomodoroLabel.frame = NSRect(x: 270, y: 20, width: 60, height: 30)
        pomodoroLabel.alignment = .center
        pomodoroLabel.font = NSFont.monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        view.addSubview(pomodoroLabel)
    }
    
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
    
    // MARK: - Theming & Customization
    private func setupTheming() {
        // Темная тема по умолчанию
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
}
