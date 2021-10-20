#
# Be sure to run `pod lib lint GithooksPreCommit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GithooksPreCommit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of GithooksPreCommit.'
  s.description      = <<-DESC
                        long long longlonglonglonglonglong description of GithooksPreCommit.
                       DESC
  s.homepage         = 'https://github.com/chenjinfei/GithooksPreCommit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chenjinfei' => 'jinfei_chen@icloud.com' }
  s.source           = { :git => 'https://github.com/chenjinfei/GithooksPreCommit.git', :tag => s.version.to_s }
  s.preserve_paths = 'githooks/*', 'scripts/*'
end
