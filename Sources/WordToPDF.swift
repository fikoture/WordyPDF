import Cocoa
import UniformTypeIdentifiers

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var window: NSWindow!
    private var selectedFiles: [URL] = []
    private var outputFolder: URL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!

    private let fileList = NSTextView()
    private let outputLabel = NSTextField(labelWithString: "")
    private let statusLabel = NSTextField(labelWithString: "DOC veya DOCX dosyalarini secin.")
    private let progress = NSProgressIndicator()
    private let convertButton = NSButton(title: "PDF'e Cevir", target: nil, action: nil)

    func applicationDidFinishLaunching(_ notification: Notification) {
        buildWindow()
        refreshFileList()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }

    private func buildWindow() {
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 720, height: 460),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "Word to PDF"
        window.center()

        let root = NSStackView()
        root.orientation = .vertical
        root.spacing = 14
        root.edgeInsets = NSEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        root.translatesAutoresizingMaskIntoConstraints = false
        window.contentView?.addSubview(root)

        NSLayoutConstraint.activate([
            root.leadingAnchor.constraint(equalTo: window.contentView!.leadingAnchor),
            root.trailingAnchor.constraint(equalTo: window.contentView!.trailingAnchor),
            root.topAnchor.constraint(equalTo: window.contentView!.topAnchor),
            root.bottomAnchor.constraint(equalTo: window.contentView!.bottomAnchor)
        ])

        let title = NSTextField(labelWithString: "Word dosyalarini PDF'e cevir")
        title.font = .boldSystemFont(ofSize: 24)
        root.addArrangedSubview(title)

        let subtitle = NSTextField(labelWithString: "DOC/DOCX dosyalarini yerel olarak LibreOffice ile PDF'e aktarir.")
        subtitle.textColor = .secondaryLabelColor
        root.addArrangedSubview(subtitle)

        let buttonRow = NSStackView()
        buttonRow.orientation = .horizontal
        buttonRow.spacing = 8
        root.addArrangedSubview(buttonRow)

        let pickButton = NSButton(title: "Dosya Sec", target: self, action: #selector(pickFiles))
        let clearButton = NSButton(title: "Listeyi Temizle", target: self, action: #selector(clearFiles))
        buttonRow.addArrangedSubview(pickButton)
        buttonRow.addArrangedSubview(clearButton)
        buttonRow.addArrangedSubview(NSView())

        let outputRow = NSStackView()
        outputRow.orientation = .horizontal
        outputRow.spacing = 8
        root.addArrangedSubview(outputRow)

        outputRow.addArrangedSubview(NSTextField(labelWithString: "Cikti klasoru:"))
        outputLabel.lineBreakMode = .byTruncatingMiddle
        outputRow.addArrangedSubview(outputLabel)
        let outputButton = NSButton(title: "Degistir", target: self, action: #selector(pickOutputFolder))
        outputRow.addArrangedSubview(outputButton)

        let scroll = NSScrollView()
        scroll.hasVerticalScroller = true
        scroll.borderType = .bezelBorder
        fileList.isEditable = false
        fileList.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        scroll.documentView = fileList
        root.addArrangedSubview(scroll)
        scroll.heightAnchor.constraint(greaterThanOrEqualToConstant: 190).isActive = true

        progress.minValue = 0
        progress.maxValue = 1
        progress.doubleValue = 0
        root.addArrangedSubview(progress)

        let bottomRow = NSStackView()
        bottomRow.orientation = .horizontal
        bottomRow.spacing = 12
        root.addArrangedSubview(bottomRow)

        statusLabel.lineBreakMode = .byTruncatingTail
        bottomRow.addArrangedSubview(statusLabel)
        convertButton.target = self
        convertButton.action = #selector(startConversion)
        convertButton.keyEquivalent = "\r"
        bottomRow.addArrangedSubview(convertButton)

        window.makeKeyAndOrderFront(nil)
    }

    @objc private func pickFiles() {
        let panel = NSOpenPanel()
        panel.title = "Word dosyalarini sec"
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [
            UTType(filenameExtension: "doc")!,
            UTType(filenameExtension: "docx")!
        ]

        guard panel.runModal() == .OK else { return }
        for url in panel.urls where !selectedFiles.contains(url) {
            selectedFiles.append(url)
        }
        refreshFileList()
    }

    @objc private func clearFiles() {
        selectedFiles.removeAll()
        progress.doubleValue = 0
        refreshFileList()
    }

    @objc private func pickOutputFolder() {
        let panel = NSOpenPanel()
        panel.title = "PDF cikti klasorunu sec"
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false

        guard panel.runModal() == .OK, let url = panel.url else { return }
        outputFolder = url
        refreshFileList()
    }

    private func refreshFileList() {
        outputLabel.stringValue = outputFolder.path
        fileList.string = selectedFiles.isEmpty
            ? "Henuz dosya secilmedi."
            : selectedFiles.map { $0.path }.joined(separator: "\n")
        statusLabel.stringValue = selectedFiles.isEmpty ? "DOC veya DOCX dosyalarini secin." : "\(selectedFiles.count) dosya hazir."
    }

    @objc private func startConversion() {
        guard !selectedFiles.isEmpty else {
            showAlert(title: "Dosya yok", message: "Once bir DOC veya DOCX dosyasi secin.")
            return
        }
        guard let soffice = findLibreOffice() else {
            showAlert(title: "LibreOffice bulunamadi", message: "LibreOffice kurulu olmali: https://www.libreoffice.org/download/")
            return
        }

        convertButton.isEnabled = false
        progress.maxValue = Double(selectedFiles.count)
        progress.doubleValue = 0
        statusLabel.stringValue = "Donusturme basladi..."

        let files = selectedFiles
        let destination = outputFolder
        DispatchQueue.global(qos: .userInitiated).async {
            var failures: [String] = []
            var successCount = 0

            for (index, file) in files.enumerated() {
                DispatchQueue.main.async {
                    self.statusLabel.stringValue = "Ceviriliyor: \(file.lastPathComponent)"
                }

                do {
                    _ = try self.convert(file: file, outputFolder: destination, soffice: soffice)
                    successCount += 1
                } catch {
                    failures.append("\(file.lastPathComponent): \(error.localizedDescription)")
                }

                DispatchQueue.main.async {
                    self.progress.doubleValue = Double(index + 1)
                }
            }

            DispatchQueue.main.async {
                self.convertButton.isEnabled = true
                self.statusLabel.stringValue = "\(successCount) PDF olusturuldu."
                if !failures.isEmpty {
                    self.showAlert(title: "Bazi dosyalar cevrilemedi", message: failures.joined(separator: "\n"))
                }
            }
        }
    }

    private func convert(file: URL, outputFolder: URL, soffice: String) throws -> URL {
        let tempFolder = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: tempFolder, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempFolder) }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: soffice)
        process.arguments = ["--headless", "--convert-to", "pdf", "--outdir", tempFolder.path, file.path]

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        try process.run()
        process.waitUntilExit()

        guard process.terminationStatus == 0 else {
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let detail = String(data: data, encoding: .utf8) ?? "Bilinmeyen LibreOffice hatasi."
            throw NSError(domain: "WordToPDF", code: Int(process.terminationStatus), userInfo: [NSLocalizedDescriptionKey: detail])
        }

        let produced = tempFolder.appendingPathComponent(file.deletingPathExtension().lastPathComponent + ".pdf")
        guard FileManager.default.fileExists(atPath: produced.path) else {
            throw NSError(domain: "WordToPDF", code: 2, userInfo: [NSLocalizedDescriptionKey: "PDF dosyasi olusturulamadi."])
        }

        let destination = uniqueOutputURL(folder: outputFolder, stem: file.deletingPathExtension().lastPathComponent)
        try FileManager.default.moveItem(at: produced, to: destination)
        return destination
    }

    private func uniqueOutputURL(folder: URL, stem: String) -> URL {
        var candidate = folder.appendingPathComponent(stem).appendingPathExtension("pdf")
        var index = 2
        while FileManager.default.fileExists(atPath: candidate.path) {
            candidate = folder.appendingPathComponent("\(stem) \(index)").appendingPathExtension("pdf")
            index += 1
        }
        return candidate
    }

    private func findLibreOffice() -> String? {
        let candidates = [
            "/Applications/LibreOffice.app/Contents/MacOS/soffice",
            "/opt/homebrew/bin/soffice",
            "/usr/local/bin/soffice"
        ]
        return candidates.first { FileManager.default.isExecutableFile(atPath: $0) }
    }

    private func showAlert(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Tamam")
        alert.runModal()
    }
}
