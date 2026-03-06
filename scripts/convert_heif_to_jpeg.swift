import Foundation
import AppKit

struct ConversionError: Error, CustomStringConvertible {
    let message: String
    var description: String { message }
}

func convert(inputPath: String, outputPath: String) throws {
    let inputURL = URL(fileURLWithPath: inputPath)
    let outputURL = URL(fileURLWithPath: outputPath)

    guard let image = NSImage(contentsOf: inputURL) else {
        throw ConversionError(message: "Unable to open image: \(inputPath)")
    }

    guard
        let tiffData = image.tiffRepresentation,
        let bitmap = NSBitmapImageRep(data: tiffData),
        let jpegData = bitmap.representation(using: .jpeg, properties: [.compressionFactor: 0.92])
    else {
        throw ConversionError(message: "Unable to encode JPEG: \(inputPath)")
    }

    try jpegData.write(to: outputURL, options: .atomic)
}

let args = CommandLine.arguments
guard args.count == 3 else {
    fputs("Usage: swift convert_heif_to_jpeg.swift <input> <output>\n", stderr)
    exit(1)
}

do {
    try convert(inputPath: args[1], outputPath: args[2])
} catch {
    fputs("\(error)\n", stderr)
    exit(1)
}
