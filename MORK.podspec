Pod::Spec.new do |s|
  s.name             = 'MORK'
  s.version          = '0.0.1'
  s.source_files     = 'MORK/MORK.{h,m}', 'MORK/ORKCollectionResult+MORK.{h,m}', 'MORK/ORKQuestionResult+MORK.{h,m}'
  s.dependency         'ResearchKit'
end
