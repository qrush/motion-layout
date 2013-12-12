#  Copyright (c) 2012 HipByte SPRL and Contributors
#
#  Permission is hereby granted, free of charge, to any person
#  obtaining a copy of this software and associated documentation
#  files (the “Software”), to deal in the Software without
#  restriction, including without limitation the rights to use,
#  copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the
#  Software is furnished to do so, subject to the following
#  conditions:
#
#  The above copyright notice and this permission notice shall be
#  included in all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
#  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#  OTHER DEALINGS IN THE SOFTWARE. 

class TimerController < UIViewController
  attr_reader :timer

  def viewDidLoad
    @state = UILabel.new
    @state.font = UIFont.systemFontOfSize(30)
    @state.text = 'Tap to start'
    @state.textAlignment = UITextAlignmentCenter
    @state.textColor = UIColor.whiteColor
    @state.backgroundColor = UIColor.clearColor

    @action = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @action.setTitle('Start', forState:UIControlStateNormal)
    @action.setTitle('Stop', forState:UIControlStateSelected)
    @action.addTarget(self, action:'actionTapped', forControlEvents:UIControlEventTouchUpInside)

    @version = UILabel.new
    @version.font = UIFont.systemFontOfSize(10)
    @version.text = 'version'
    @version.textAlignment = UITextAlignmentRight
    @version.textColor = UIColor.whiteColor
    @version.backgroundColor = UIColor.clearColor

    @versionNumber = UILabel.new
    @versionNumber.font = UIFont.systemFontOfSize(19)
    @versionNumber.text = '0.1.0'
    @versionNumber.textAlignment = UITextAlignmentRight
    @versionNumber.textColor = UIColor.whiteColor
    @versionNumber.backgroundColor = UIColor.clearColor

    Motion::Layout.new do |layout|
      layout.view view
      layout.subviews "state" => @state, "action" => @action, "version" => @version, "version_number" => @versionNumber
      layout.metrics "top" => 200, "margin" => 20, "height" => 40
      layout.vertical "|-top-[state(==height)]-margin-[action(==height)]"
      layout.vertical "[version]|"
      layout.horizontal "|-margin-[state]-margin-|"
      layout.horizontal "|-margin-[action]-margin-|"
      layout.horizontal "[version]-5-[version_number]|", :baseline
    end
  end

  def actionTapped
    if @timer
      @timer.invalidate
      @timer = nil
    else
      @duration = 0
      @timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:'timerFired', userInfo:nil, repeats:true)
    end
    @action.selected = !@action.selected?
  end

  def timerFired
    @state.text = "%.1f" % (@duration += 0.1)
  end
end
