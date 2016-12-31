Pod::Spec.new do |s|
  s.name             = "Polymerase"
  s.version          = "1.0.0-beta1"
  s.summary          = "Dependency injection framework for Objective C and Swift"
  s.description      = <<-DESC
                       Polymerase is a service-oriented, Objective C and Swift dependency injection framework, for macOS and iOS.
                       Features dynamic Xcode storyboard integration for services and parameters.
                       DESC
  s.homepage         = "https://github.com/GroovyCarrot/Polymerase"
  s.license          = 'APACHE'
  s.author           = 'GroovyCarrot'
  s.source           = { :git => "https://github.com/GroovyCarrot/Polymerase.git", :tag => s.version.to_s }

  s.source_files = 'Source/**/*.{m,h}'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
  s.requires_arc = true
end
