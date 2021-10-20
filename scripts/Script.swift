#!/usr/bin/swift

import Foundation

let projectType = "-workspace"
let projectPath = "SyncGithooksDemo.xcworkspace"
let scheme = "SyncGithooksDemo"
let destinationDevice = "platform=iOS Simulator,name=iPhone 11 Pro Max"
let resultBundlePath = "PrePush.xcresult"

print("Building for testing…")
let buildCommand = [
    "xcodebuild",
    "build-for-testing",
    "-quiet",
    projectType, projectPath.wrappedInQuotes,
    "-scheme", scheme.wrappedInQuotes,
    "-destination", destinationDevice.wrappedInQuotes
].joined(separator: " ")
let buildStatus = Process.runZshCommand(buildCommand)
if buildStatus != 0 {
    exit(buildStatus)
}

removeResultBundle(at: resultBundlePath)

print("Running tests…")
let testCommand = [
    "xcodebuild",
    "test-without-building",
    "-quiet",
    projectType, projectPath.wrappedInQuotes,
    "-scheme", scheme.wrappedInQuotes,
    "-destination", destinationDevice.wrappedInQuotes,
    "-resultBundlePath", resultBundlePath.wrappedInQuotes
].joined(separator: " ")
let testStatus = Process.runZshCommand(testCommand)
if testStatus != 0 {
    removeResultBundle(at: resultBundlePath)
    exit(testStatus)
}

let coverageCommand = [
    "xcrun",
    "xccov",
    "view",
    "–only-targets",
    "–report", resultBundlePath.wrappedInQuotes
].joined(separator: " ")
Process.runZshCommand(coverageCommand)

removeResultBundle(at: resultBundlePath)

print("Success")
exit(0)

// MARK: –
extension String {
    var wrappedInQuotes: String {
        return "\"\(self)\""
    }
}

extension Process {
    @discardableResult
    static func runZshCommand(_ command: String) -> Int32 {
        let process = Process()
        process.launchPath = "/bin/zsh"
        process.arguments = ["-c", command]
        process.standardOutput = {
            let pipe = Pipe()
            pipe.fileHandleForReading.readabilityHandler = { handler in
                guard let string = String(data: handler.availableData, encoding: .utf8), !string.isEmpty else { return }
                print(string)
            }
            return pipe
        }()
        process.standardError = {
            let pipe = Pipe()
            pipe.fileHandleForReading.readabilityHandler = { handler in
                guard let string = String(data: handler.availableData, encoding: .utf8), !string.isEmpty else { return }
                print(string)
            }
            return pipe
        }()
        process.launch()
        process.waitUntilExit()
        (process.standardOutput as! Pipe).fileHandleForReading.readabilityHandler = nil
        (process.standardError as! Pipe).fileHandleForReading.readabilityHandler = nil
        return process.terminationStatus
    }
}

func removeResultBundle(at path: String) {
    guard FileManager.default.fileExists(atPath: path) else { return }
    try? FileManager.default.removeItem(atPath: path)
}
