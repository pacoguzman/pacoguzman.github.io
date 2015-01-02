---
layout: post
title: How we speed up our test suite
date: 2015-01-02 12:20:24
description: "You can reduce your build time taking a look to what you're doing in your specs"
tags: ['ci', 'rails', 'rspec', 'paperclip']
---

At [BeBanjo](http://www.bebanjo.com) we run the test suite of our applications in a custom installation of [Vexor CI](https://vexor.io/) a cloud continuous integration server using two bare metal servers. And in this post I'll try to explain how we speed up a little bit our test suite for our more pushed application.

Before the change the build spent around 10 minutes to complete, we parallelize the build process on 8 jobs than can be run in parallel, we execute 4 jobs per server. So the total time is the one from the less performance job.

<img src="/img/posts/2015-01-02-complete.png" alt="Image of the previous complete process" class="media-center media-border" />

But the time running the specs is only around 8:30 so we start reducing the number of jobs that conform the build to 6 jobs only increasing the total time on 1 minute (doing some sums and subtractions) and leaving 2 jobs for other pushes of this application or to run other applications' build.

Later to detect what were the less performance specs we activated the [profile](https://www.relishapp.com/rspec/rspec-core/v/3-1/docs/configuration/profile-examples) capibilities on our rspec configuration

{% highlight ruby %}
# spec/spec_helper.rb
RSpec.configure do |config|
  config.profile_examples = 20 if ENV['CI']
end
{% endhighlight %}

With that we detected that the specs that need sphinx to pass were spending more time than expected, so we change some specs that didn't need that dependency to be there and for the rest we decide to always start sphinx for the suite when running on our CI server. Reviewing the thinking sphinx code there are some sleep statements when starting and stoping the sphinx daemon that introduce a penalty when running the whole suite.

{% highlight ruby %}
# spec/support/sphinx.rb
RSpec.configure do |config|
  # On CI we start sphinx only once
  if ENV['CI']
    config.before(:suite) { ThinkingSphinx::Test.start }
    config.after(:suite) { ThinkingSphinx::Test.stop }
  else
    config.before { ThinkingSphinx::Test.start if example.metadata[:sphinx] }
    config.after  { ThinkingSphinx::Test.stop  if example.metadata[:sphinx] }
  end
end
{% endhighlight %}

Later we checked that some specs that ensure the correct behaviour of some custom paperclip extensions spent a lot of time because we test a lot of combinations. The time spent in these specs are mostly related with the commands paperclip execute to generate the thumbnails like the convert and identify command executed through the cocaine gem. To avoid that commands, because we're not testing those we decided to swap the cocaine command line class to use a custom class that don't do anything against the file system, for this we used the [stub_const](https://www.relishapp.com/rspec/rspec-mocks/v/3-1/docs/mutating-constants/stub-defined-constant)

{% highlight ruby %}
# spec/support/paperclip.rb
require 'fileutils'

module LightCocaine
  class CommandLine < Cocaine::CommandLine
    # See Paperclip::Thumbnail to now the parameters send to cocaine
    def run
      if command =~ /^convert/
        FileUtils.cp(@options[:source].gsub(/\[0\]\Z/, ''), @options[:dest])
      elsif command =~ /^identify/
        "400x400"
      else
        super
      end
    end
  end
end

RSpec.configure do |config|
  config.before do
    if example.metadata[:stub_cocaine]
      stub_const 'Cocaine::CommandLine', LightCocaine::CommandLine
    end
  end
end
{% endhighlight %}

So finally we run our test suite in aroung 7:30 minutes so we improved around a 25% of time (10 to 7.5 minutes) and 25% of server resources (8 to 6 jobs).

<img src="/img/posts/2015-01-02-new-complete.png" alt="Image of the new complete process" class="media-center media-border" />

