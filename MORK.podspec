Pod::Spec.new do |s|
  s.name             =  'MORK'
  s.version          =  '0.0.1'
s.source_files     = 'MORK/MORK.h', 'MORK/ORKCollectionResult+MORK.m', 'MORK/ORKTaskResult+MORK.h', 'MORK/ORKQuestionResult+MORK.{h,m}'
  s.dependency       'ResearchKit'
end
