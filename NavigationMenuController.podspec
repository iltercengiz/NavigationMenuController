Pod::Spec.new do |s|
    s.name             = "NavigationMenuController"
    s.version          = "0.1.0"
    s.summary          = "A UINavigationController subclass that adds a menu button in navigation bar to navigate through view controllers from a dropdown menu."
    s.description      = <<-DESC
                            A menu can be revealed via a button added to the navigation bar.
                            Any selection from the menu will replace the last view controller on the stack, replacing the current view controller.
                         DESC
    s.homepage         = "https://github.com/iltercengiz/NavigationMenuController"
    s.license          = 'MIT'
    s.author           = { "Ilter Cengiz" => "iltercengiz@yahoo.com" }
    s.source           = { :git => "https://github.com/iltercengiz/NavigationMenuController.git", :tag => s.version.to_s }
    s.social_media_url = 'https://twitter.com/iltercengiz'

    s.platform     = :ios, '7.0'
    s.requires_arc = true

    s.source_files = 'Pod/Classes/**/*'
    
    s.dependency 'LiveFrost'
end