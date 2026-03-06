#!/usr/bin/env swift

import AppKit
import Foundation
import Vision

struct OCRPage: Encodable {
    let id: String
    let file: String
    let text: String
}

struct OCRManifest: Encodable {
    let generatedAt: String
    let sourceDirectory: String
    let pageCount: Int
    let pages: [OCRPage]
}

func fail(_ message: String) -> Never {
    fputs("error: \(message)\n", stderr)
    exit(1)
}

func resolvePath(_ path: String) -> URL {
    if path.hasPrefix("/") {
        return URL(fileURLWithPath: path)
    }

    return URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        .appendingPathComponent(path)
}

func recognizeText(from imageURL: URL) throws -> String {
    let request = VNRecognizeTextRequest()
    request.recognitionLevel = .accurate
    request.recognitionLanguages = ["en-US"]
    request.usesLanguageCorrection = true
    request.minimumTextHeight = 0.01

    let handler = VNImageRequestHandler(url: imageURL, options: [:])
    try handler.perform([request])

    let observations = request.results ?? []
    let lines = observations.compactMap { observation in
        observation.topCandidates(1).first?.string.trimmingCharacters(in: .whitespacesAndNewlines)
    }.filter { !$0.isEmpty }

    return lines.joined(separator: "\n")
}

let args = CommandLine.arguments
let inputArg = args.count > 1 ? args[1] : "imgs"
let outputArg = args.count > 2 ? args[2] : "ocr-output"

let inputURL = resolvePath(inputArg)
let outputURL = resolvePath(outputArg)
let fm = FileManager.default

var isDirectory: ObjCBool = false
guard fm.fileExists(atPath: inputURL.path, isDirectory: &isDirectory), isDirectory.boolValue else {
    fail("input directory not found: \(inputURL.path)")
}

try fm.createDirectory(at: outputURL, withIntermediateDirectories: true)

let files = try fm.contentsOfDirectory(at: inputURL, includingPropertiesForKeys: nil)
    .filter { url in
        let name = url.lastPathComponent.lowercased()
        return name.hasPrefix("page-") && (name.hasSuffix(".jpeg") || name.hasSuffix(".jpg") || name.hasSuffix(".png"))
    }
    .sorted { $0.lastPathComponent < $1.lastPathComponent }

if files.isEmpty {
    fail("no page images found in \(inputURL.path)")
}

var pages: [OCRPage] = []

for fileURL in files {
    let baseName = fileURL.deletingPathExtension().lastPathComponent
    let components = baseName.split(separator: "-")
    let id = components.count >= 2 ? "\(components[0])-\(components[1])" : baseName
    let text = try recognizeText(from: fileURL)
    let cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
    let page = OCRPage(id: id, file: fileURL.lastPathComponent, text: cleaned)
    pages.append(page)

    let pageOutputURL = outputURL.appendingPathComponent("\(id).txt")
    try cleaned.write(to: pageOutputURL, atomically: true, encoding: .utf8)
}

let encoder = JSONEncoder()
encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

let manifest = OCRManifest(
    generatedAt: ISO8601DateFormatter().string(from: Date()),
    sourceDirectory: inputURL.path,
    pageCount: pages.count,
    pages: pages
)

let manifestURL = outputURL.appendingPathComponent("pages.json")
let data = try encoder.encode(manifest)
try data.write(to: manifestURL)

print("OCR complete: \(pages.count) pages")
print("Output: \(outputURL.path)")
