// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "FontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias Font = FontConvertible.Font

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
internal enum FontFamily {
  internal enum Urbanist {
    internal static let regular = FontConvertible(name: "Urbanist-Regular", family: "Urbanist", path: "Urbanist-VariableFont_wght.ttf")
    internal static let black = FontConvertible(name: "UrbanistRoman-Black", family: "Urbanist", path: "Urbanist-VariableFont_wght.ttf")
    internal static let bold = FontConvertible(name: "UrbanistRoman-Bold", family: "Urbanist", path: "Urbanist-VariableFont_wght.ttf")
    internal static let extraBold = FontConvertible(name: "UrbanistRoman-ExtraBold", family: "Urbanist", path: "Urbanist-VariableFont_wght.ttf")
    internal static let extraLight = FontConvertible(name: "UrbanistRoman-ExtraLight", family: "Urbanist", path: "Urbanist-VariableFont_wght.ttf")
    internal static let light = FontConvertible(name: "UrbanistRoman-Light", family: "Urbanist", path: "Urbanist-VariableFont_wght.ttf")
    internal static let medium = FontConvertible(name: "UrbanistRoman-Medium", family: "Urbanist", path: "Urbanist-VariableFont_wght.ttf")
    internal static let semiBold = FontConvertible(name: "UrbanistRoman-SemiBold", family: "Urbanist", path: "Urbanist-VariableFont_wght.ttf")
    internal static let thin = FontConvertible(name: "UrbanistRoman-Thin", family: "Urbanist", path: "Urbanist-VariableFont_wght.ttf")
    internal static let all: [FontConvertible] = [regular, black, bold, extraBold, extraLight, light, medium, semiBold, thin]
  }
  internal static let allCustomFonts: [FontConvertible] = [Urbanist.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  #if os(macOS)
  internal typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Font = UIFont
  #endif

  internal func font(size: CGFloat) -> Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return font
  }

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension FontConvertible.Font {
  convenience init?(font: FontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(macOS)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
