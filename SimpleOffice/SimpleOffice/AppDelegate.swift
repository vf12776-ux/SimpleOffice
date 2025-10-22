import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Настройка приложения
        setupAppearance()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Сохранение состояния при выходе
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    private func setupAppearance() {
        // Настройка темной темы
        if #available(macOS 10.14, *) {
            NSApp.appearance = NSAppearance(named: .darkAqua)
        }
    }
}
