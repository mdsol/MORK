Pod::Spec.new do |s|
  s.name             =  'MORK'
  s.version          =  '0.0.1'
  s.source_files     = 'MORK/MORK.h', 'MORK/ORKCollectionResult+MORK.h'

  s.dependency       'ResearchKit'
end
