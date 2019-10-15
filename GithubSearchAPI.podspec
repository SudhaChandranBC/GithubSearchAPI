Pod::Spec.new do |spec|

spec.name         = "GithubSearchAPI"
spec.version      = "0.0.1"
spec.summary      = "Swift implementation of Github Repository Search API."

spec.homepage     = "https://github.com/SudhaChandranBC/GithubSearchAPI"
spec.license      = { :type => "MIT", :file => "LICENSE" }
spec.author             = { "Chandran, Sudha" => "sudhachandran1bc@gmail.com" }

spec.ios.deployment_target = "9.0"
spec.swift_version = "5.0"
spec.source       = { :git => "https://github.com/SudhaChandranBC/GithubSearchAPI.git", :tag => "#{spec.version}" }
spec.source_files  = "GithubSearchAPI/GithubSearchAPI.swift"

end
