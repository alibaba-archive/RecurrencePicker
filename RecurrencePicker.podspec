Pod::Spec.new do |s|
  s.name = 'RecurrencePicker'
  s.version = '4.0.1'
  s.license = 'MIT'
  s.summary = 'An event recurrence rule picker similar to iOS system calendar'
  s.homepage = 'https://github.com/teambition/RecurrencePicker'
  s.social_media_url = 'https://twitter.com/teambition'
  s.authors = { 'Xin Hong' => '', 'Alexander Evsyuchenya' => '' }
  s.source = { :git => 'https://github.com/teambition/RecurrencePicker.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.ios.frameworks = 'UIKit', 'Foundation'
  s.source_files = 'RecurrencePicker/*.swift', 'RecurrencePicker/*.xib'
  s.resources = 'RecurrencePicker/Resources/*'
  s.requires_arc = true
  s.dependency 'RRuleSwift'
end
