import Cocoa

class SimpleFileManager {
    
    static let shared = SimpleFileManager()
    
    private init() {}
    
    // MARK: - 4. File System Integration
    func saveFile(content: String, fileName: String) -> Bool {
        let dialog = NSSavePanel()
        dialog.title = "Сохранить файл"
        dialog.allowedContentTypes = [.plainText, .pdf, .html]
        dialog.nameFieldStringValue = fileName
        
        if dialog.runModal() == .OK, let url = dialog.url {
            do {
                try content.write(to: url, atomically: true, encoding: .utf8)
                return true
            } catch {
                print("Ошибка сохранения: \(error)")
                return false
            }
        }
        return false
    }
    
    func openFile() -> String? {
        let dialog = NSOpenPanel()
        dialog.title = "Выберите файл"
        dialog.allowedContentTypes = [.plainText, .pdf, .html]
        
        if dialog.runModal() == .OK, let url = dialog.url {
            do {
                return try String(contentsOf: url, encoding: .utf8)
            } catch {
                print("Ошибка открытия: \(error)")
            }
        }
        return nil
    }
    
    // MARK: - 5. Multi-format Export
    func exportToPDF(content: String, fileName: String) -> Bool {
        // Простая реализация экспорта в PDF
        let printInfo = NSPrintInfo.shared
        let printOperation = NSPrintOperation(view: createPDFView(content: content), printInfo: printInfo)
        printOperation.showsPrintPanel = false
        printOperation.showsProgressPanel = false
        
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = "\(fileName).pdf"
        
        if savePanel.runModal() == .OK, let url = savePanel.url {
            printOperation.printInfo.dictionary()[NSPrintInfo.AttributeKey.jobDisposition] = NSPrintInfo.JobDisposition.save
            printOperation.printInfo.dictionary()[NSPrintInfo.AttributeKey.jobSavingURL] = url
            printOperation.run()
            return true
        }
        return false
    }
    
    private func createPDFView(content: String) -> NSView {
        let textView = NSTextView(frame: NSRect(x: 0, y: 0, width: 595, height: 842)) // A4
        textView.string = content
        textView.font = NSFont.systemFont(ofSize: 12)
        return textView
    }
}
