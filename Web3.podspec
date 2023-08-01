Pod::Spec.new do |s|
  s.name             = 'Web3'
  s.version          = '0.2.1'
  s.summary          = 'Web3 library for Swift. Sign transactions and interact with Smart Contracts in the Ethereum Network.'

  s.description      = <<-DESC
Web3 library to sign transactions, interact with Smart Contracts, call
Smart Contract methods and many things more, all through either a
HTTP RPC interface provided by this library or a custom RPC interface
(for example IPC,...).
                       DESC

  s.homepage         = 'https://github.com/Boilertalk/Web3.swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Koray Koska' => 'koray@koska.at' }
  s.source           = { :git => 'https://github.com/Boilertalk/Web3.swift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.pod_target_xcconfig = {
    'OTHER_SWIFT_FLAGS' => '-DWeb3CocoaPods'
  }

  s.default_subspecs = 'Core', 'HTTPExtension'

  s.subspec 'Core' do |ss|
    ss.source_files = 'Web3/Classes/Core/**/*'

    # Core dependencies
    ss.dependency 'BigInt', '~> 3.1'
    ss.dependency 'CryptoSwift', '~> 0.8'
    ss.dependency 'secp256k1.swift', '~> 0.1'
  end

  s.subspec 'HTTPExtension' do |ss|
    ss.source_files = 'Web3/Classes/FoundationHTTP/**/*'

    ss.dependency 'Web3/Core'
  end

  s.subspec 'PromiseKit' do |ss|
    ss.source_files = 'Web3/Classes/PromiseKit/**/*'

    ss.dependency 'Web3/Core'
    # PromiseKit dependency
    ss.dependency 'PromiseKit/CorePromise', '~> 6.0'
  end

  s.subspec 'ContractABI' do |ss|
    ss.source_files = 'Web3/Classes/ContractABI/**/*'

    ss.dependency 'Web3/Core'
  end

  # s.resource_bundles = {
  #   'Web3' => ['Web3/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
