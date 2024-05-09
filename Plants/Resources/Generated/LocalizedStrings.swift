// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Auth {
    internal enum Email {
      /// Введите E-mail...
      internal static let placeholder = L10n.tr("Localizable", "Auth.Email.placeholder")
      /// Логин
      internal static let title = L10n.tr("Localizable", "Auth.Email.title")
    }
    internal enum LoginButton {
      /// Войти
      internal static let title = L10n.tr("Localizable", "Auth.LoginButton.title")
    }
    internal enum Password {
      /// Подтвердите пароль...
      internal static let placeholder = L10n.tr("Localizable", "Auth.Password.placeholder")
      /// Пароль
      internal static let title = L10n.tr("Localizable", "Auth.Password.title")
    }
    internal enum PasswordAgain {
      /// Подтверждение
      internal static let title = L10n.tr("Localizable", "Auth.PasswordAgain.title")
    }
    internal enum RegisterButton {
      /// Зарегистрироваться
      internal static let title = L10n.tr("Localizable", "Auth.RegisterButton.title")
    }
  }

  internal enum Scanner {
    internal enum Analyze {
      /// Проанализировать
      internal static let title = L10n.tr("Localizable", "Scanner.Analyze.title")
    }
    internal enum Loading {
      /// Идет обработка.
      /// Подождите...
      internal static let message = L10n.tr("Localizable", "Scanner.Loading.message")
    }
    internal enum Result {
      /// Заболевание:
      /// %@
      internal static func plantDisease(_ p1: Any) -> String {
        return L10n.tr("Localizable", "Scanner.Result.plantDisease", String(describing: p1))
      }
      /// Вид растения:
      /// %@
      internal static func plantSpecies(_ p1: Any) -> String {
        return L10n.tr("Localizable", "Scanner.Result.plantSpecies", String(describing: p1))
      }
      /// Результат
      internal static let title = L10n.tr("Localizable", "Scanner.Result.title")
    }
    internal enum RetakePhoto {
      /// Переснять
      internal static let title = L10n.tr("Localizable", "Scanner.RetakePhoto.title")
    }
    internal enum TakePhoto {
      /// Сделать фото
      internal static let title = L10n.tr("Localizable", "Scanner.TakePhoto.title")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
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
