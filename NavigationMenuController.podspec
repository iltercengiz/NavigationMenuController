Pod::Spec.new do |s|
    s.name             = "NavigationMenuController"
    s.version          = "0.1.0"
    s.summary          = "A short description of NavigationMenuController."
    s.description      = <<-DESC
                            An optional longer description of NavigationMenuController

                            * Markdown format.
                            * Don't worry about the indent, we strip it!
                         DESC
    s.homepage         = "https://github.com/iltercengiz/NavigationMenuController"
    # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
    s.license          = 'MIT'
    s.author           = { "Ilter Cengiz" => "iltercengiz@yahoo.com" }
    s.source           = { :git => "https://github.com/iltercengiz/NavigationMenuController.git", :tag => s.version.to_s }
    s.social_media_url = 'https://twitter.com/iltercengiz'

    s.platform     = :ios, '7.0'
    s.requires_arc = true

    s.source_files = 'Pod/Classes/**/*'
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
end
