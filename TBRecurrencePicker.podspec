#
#  Created by teambition-ios on 2020/7/27.
#  Copyright © 2020 teambition. All rights reserved.
#     

Pod::Spec.new do |s|
  s.name             = 'TBRecurrencePicker'
  s.version          = '0.1.4'
  s.summary          = 'An event recurrence rule picker similar to iOS system calendar.'
  s.description      = <<-DESC
  An event recurrence rule picker similar to iOS system calendar.
                       DESC

  s.homepage         = 'https://github.com/teambition/RecurrencePicker'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'teambition mobile' => 'teambition-mobile@alibaba-inc.com' }
  s.source           = { :git => 'https://github.com/teambition/RecurrencePicker.git', :tag => s.version.to_s }

  s.swift_version = '5.0'
  s.ios.deployment_target = '8.0'

  s.source_files = 'RecurrencePicker/*.{swift,xib}'
  s.ios.resource_bundle = { 
    'RecurrencePicker' => 'RecurrencePicker/Resources/RecurrencePicker.xcassets',
    'LocalizedStrings' => 'RecurrencePicker/Resources/LocalizedStrings/*.lproj/*'
  }

  s.dependency 'RRuleSwift'
  #, :git => 'https://github.com/teambition/RRuleSwift.git' 
  # dependency无法指定git
  # RRuleSwift仓库没有提交到Cocoapods
  # 在项目中pod RecurrencePicker后还需要指定:
  # `pod 'RRuleSwift', :git => 'https://github.com/teambition/RRuleSwift.git'`
end
