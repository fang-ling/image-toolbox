import ArgumentParser

let VERSION = "0.0.1"

@main
struct pxm : ParsableCommand {
    static var configuration = CommandConfiguration(
      abstract:
        "A utility for displaying, converting, " +
        "and editing raster image files.",
      version: VERSION,
      subcommands: [Dedup.self]
    )
}
