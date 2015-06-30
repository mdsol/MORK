Pod::Spec.new do |s|
  s.name            =   'MORK'
  s.version         =   '0.0.1'
  s.summary         =   "Extends Apple's ResearchKit to integrate with the Medidata Patient Cloud Gateway"
  s.homepage        =   'https://github.com/mdsol/MORK'
  s.source          =   { git: 'https://github.com/mdsol/MORK.git', :tag => s.version.to_s }
  s.source_files    =   'MORK/MORK.h',
                        'MORK/ORKTaskResult+MORK.{h,m}',
                        'MORK/ORKQuestionResult+MORK.{h,m}'

  s.ios.deployment_target   = '8.0'
  s.platform                = :ios, '8.0'
  s.requires_arc            = true

  s.dependency          'ResearchKit'
end


