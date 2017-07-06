Pod::Spec.new do |s|

  s.name         = "OperationStepView"
  s.version      = "0.1.0"  
  s.summary      = "OperationStep is used for show you operation."
  s.description  = <<-DESC
                   It is a component for ios to operation,written by Objective-C.
                   DESC
  s.homepage     = "https://github.com/yao996186979/OperationStep"
  s.license      = "MIT"
  s.author       = {"yaodong" => "1248170343@qq.com"}
  s.source       = { :git => "https://github.com/yao996186979/OperationStep.git", :tag => "0.1.0" }
  s.source_files  ="OperationStepDemo/OperationStepDemo/PGOperationView/**/*.{h,m}"
  s.requires_arc = true
  s.framework  = "UIKit"
  s.ios.deployment_target = '8.0'
end
