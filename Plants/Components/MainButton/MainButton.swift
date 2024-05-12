//
//  MainButton.swift
//  Plants
//
//  Created by Никита Афанасьев on 09.05.2024.
//

import UIKit

final class MainButton: UIButton {
    
    struct Configuration {
        struct Icon {
            enum Alignment {
                case leading
                case trailing
            }
            
            let image: UIImage
            let alignment: Alignment
        }
        
        let title: String
        let icon: Icon?
        let tintColor: UIColor
        let backgroundColor: UIColor
    }
    
    private enum Constants {
        static let fontSize: CGFloat = 18
        static let contentInsets = NSDirectionalEdgeInsets(
            top: 16,
            leading: 16,
            bottom: 16,
            trailing: 16
        )
        static let titleToIconInset: CGFloat = 12
    }
    
    var isLoading: Bool = false {
        didSet {
            updateLoading()
        }
    }
    
    func configure(with configuration: Configuration) {
        var config = UIButton.Configuration.filled()
        config.title = configuration.title
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ [weak self] container in
            guard let self else { return container }
            var result = container
            result.font = FontFamily.Urbanist.extraBold.font(size: Constants.fontSize)
            switch state {
            case .disabled:
                result.foregroundColor = Assets.Colors.brown.color
            case .normal:
                result.foregroundColor = configuration.tintColor
            default:
                break
            }
            
            return result
        })
        config.imageColorTransformer = .init({ [weak self] in
            guard let self else { return $0 }
            switch state {
            case .disabled:
                return Assets.Colors.brown.color
            case .normal:
                return configuration.tintColor
            default:
                return $0
            }
        })  
        
        config.activityIndicatorColorTransformer = .init({ [weak self] in
            guard let self else { return $0 }
            switch state {
            case .disabled:
                return Assets.Colors.brown.color
            case .normal:
                return configuration.tintColor
            default:
                return $0
            }
        })
        
        config.image = configuration.icon?.image
        if let icon = configuration.icon {
            switch icon.alignment {
            case .leading:
                config.imagePlacement = .leading
            case .trailing:
                config.imagePlacement = .trailing
            }
        }
        
        config.cornerStyle = .capsule
        config.contentInsets = Constants.contentInsets
        config.imagePadding = Constants.titleToIconInset
        config.baseBackgroundColor = configuration.backgroundColor
        config.baseForegroundColor = configuration.tintColor
        
        configurationUpdateHandler = { button in
            switch button.state {
            case .disabled:
                button.configuration?.background.backgroundColor = Assets.Colors.paleBrown.color
            case .normal:
                button.configuration?.background.backgroundColor = configuration.backgroundColor
            default:
                break
            }
        }
        
        self.configuration = config
    }
    
    private func updateLoading() {
        configuration?.showsActivityIndicator = isLoading
        isEnabled = !isLoading
    }
}
