---
layout: post
title: RSpec stub_const to bypass APIs
date: 2015-03-23 07:56:34
description: "If you're building complex mocks to bypass some internals of your app maybe you need to use stub_const"
tags: ['rails', 'rspec', 'rspec-mocks', 'mocks']
---

When you're using RSpec to implement your tests and you finish building complex mocks to avoid the execution of some internal part of your application or to substitute its implementation you can finish with something like

{% highlight ruby %}
before(:each) do
  allow_any_instance_of(App::BusinessClass::Internal).to receive(:call) do |instance, first_argument|
    ["SUCCESS"]
  end
end
{% endhighlight %}

If you read the RSpec-Mocks documentation about that rspec-mock [method](https://relishapp.com/rspec/rspec-mocks/v/3-2/docs/working-with-legacy-code/any-instance) you'll see that the developers of RSpec don't recommend its usage. Probably they are right maybe you have a bad design or your test is trying to do too much or the object you're testing is too complex.

If you think you're testing the right think and you don't find a better design I think the proper way to provide a substitute implementation is using stub_const. The previous code can be written as

{% highlight ruby %}
class App::BusinessClass::InternalMock < App::BusinessClass::InternalMock
  def call(arg)
    ["SUCCESS"]
  end
end

before(:each) do
  stub_const "App::BusinessClass::Internal", App::BusinessClass::InternalMock
end
{% endhighlight %}

This can be useful to provide alternative implementation of external API consumers or to speed up some specs as we're doing with Paperclip
