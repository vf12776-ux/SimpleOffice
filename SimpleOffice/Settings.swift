import Cocoa

class Settings {
    
    static let shared = Settings()
    
    private let defaults = UserDefaults.standard
    
    private init() {
        // Загрузка настроек при инициализации
        if defaults.value(forKey: "isDarkMode") == nil {
            defaults.set(true, forKey: "isDarkMode")
        }
    }
    
    var isDarkMode: Bool {
        get {
            return defaults.bool(forKey: "isDarkMode")
        }
        set {
            defaults.set(newValue, forKey: "isDarkMode")
            applyTheme()
        }
    }
    
    func applyTheme() {
        if #available(macOS 10.14, *) {
            NSApp.appearance = NSAppearance(named: isDarkMode ? .darkAqua : .aqua)
        }
    }
}
