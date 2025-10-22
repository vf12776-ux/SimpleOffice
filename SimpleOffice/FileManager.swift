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
                // Определяем тип по расширению
                if url.pathExtension == "pdf" {
                    return exportToPDF(content: content, fileName: url.deletingPathExtension().lastPathComponent, saveURL: url)
                } else if url.pathExtension == "html" {
                    return try exportToHTML(content: content, saveURL: url)
                } else {
                    // По умолчанию текстовый файл
                    try content.write(to: url, atomically: true, encoding: .utf8)
                    return true
                }
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
                if url.pathExtension == "pdf" {
                    // Пока не реализовано, но можно добавить конвертер PDF в текст
                    return "PDF файл. Текст пока не извлечен."
                } else if url.pathExtension == "html" {
                    return try String(contentsOf: url, encoding: .utf8)
                } else {
                    return try String(contentsOf: url, encoding: .utf8)
                }
            } catch {
                print("Ошибка открытия: \(error)")
            }
        }
        return nil
    }
    
    // MARK: - 5. Multi-format Export
    func exportToPDF(content: String, fileName: String, saveURL: URL) -> Bool {
        let printInfo = NSPrintInfo.shared
        let printOperation = NSPrintOperation(view: createPDFView(content: content), printInfo: printInfo)
        printOperation.showsPrintPanel = false
        printOperation.showsProgressPanel = false
        
        printOperation.printInfo.dictionary()[NSPrintInfo.AttributeKey.jobDisposition] = NSPrintInfo.JobDisposition.save
        printOperation.printInfo.dictionary()[NSPrintInfo.AttributeKey.jobSavingURL] = saveURL
        printOperation.run()
        return true
    }
    
    private func createPDFView(content: String) -> NSView {
        let textView = NSTextView(frame: NSRect(x: 0, y: 0, width: 595, height: 842)) // A4
        textView.string = content
        textView.font = NSFont.systemFont(ofSize: 12)
        return textView
    }
    
    private func exportToHTML(content: String, saveURL: URL) throws -> Bool {
        let htmlContent = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <title>Document</title>
        </head>
        <body>
            <pre>\(content)</pre>
        </body>
        </html>
        """
        try htmlContent.write(to: saveURL, atomically: true, encoding: .utf8)
        return true
    }
}
