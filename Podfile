# Uncomment this line to define a global platform for your project
platform :ios, "7.0"

target "ferriestimetable2" do
  pod 'PDTSimpleCalendar', '~> 0.7.0'
  pod 'Mixpanel'
end

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-ferriestimetable2/Pods-ferriestimetable2-acknowledgements.plist', 'ferrytimetable2/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end

target "ferriestimetable2Tests" do

end

link_with "ferriestimetable2Tests"

class ::Pod::Generator::Acknowledgements
  def header_text
    "Location and Calendar icon: http://icons8.com/"
  end
end
