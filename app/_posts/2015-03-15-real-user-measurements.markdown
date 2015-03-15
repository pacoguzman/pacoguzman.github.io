---
layout: post
title: Real User Measurements
date: 2015-03-15 09:56:15
description: "Simpler Real User Measurements for Rails apps"
tags: ['rails', 'rum', 'browser metrics']
---

At [BeBanjo](http://www.bebanjo.com) we use [lograge](https://github.com/roidrage/lograge) in our Rails apps so we get only one line of logging information per request that can be properly processed.

These application logs are managed by a logstash instance that we use to gather some metrics, store all the events logs to a elasticsearch instance and some other things. Our Rails apps already use NewRelic so we have the default NewRelic features by default in all our apps this includes server side metrics and browser/user metrics. But one of the problems of NewRelic is its retention policy and lack of flexibility in its free plan.

That's why as we have all our apps log events already in elasticsearch we decided to build our own browser metrics using our existing infrastructure. I forgot it but we are sending some of our metrics to [Librato](https://metrics.librato.com) from our logstash instance too.

To-do this we implemented a Rails engine that is mounted in each Rails app which browser metrics we want to measure, basically the engine is form by:

1. A piece of javascript that using the [Navigation Timing API](http://www.w3.org/TR/navigation-timing/) sends browser information on each request to the application itself.

2. A controller that will log the information that we get from the user browser and as we use lograge will be processed as any other request.

The javascript code retrieve the Navigation Timing information when a new page is loaded and on the `onload` window event send that information on an AJAX post request to the url where we mounted the engine.

{% highlight js %}
window.addEventListener("DOMContentLoaded", function() {
  var data = window.performance.timing;
    url = '/_stats', // where you mounted the engine
    request = new XMLHttpRequest();

  request.open('POST', url, true);
  request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
  request.send(data);
}, false);
{% endhighlight %}

And the controller logs all that information as a normal requests.

{% highlight sh %}
2015-03-15T06:33:40+00:00 production-web06 app-movida: method=POST path=/_rum/stats format=*/* controller=bebanjo_rum/stats action=create status=200 duration=3.10 db=0.67 timestamp=2015-03-15T06:33:40+00:00 uuid=C17125076B4E_0A23992001BB_550527C2_XXXX794EC9 client_ip=XXX.XXX.XX.X params={"timing":{"crossBrowserLoadEvent":"1426401219807","firstPaint":"0","loadTime":"4220","domReadyTime":"1655","readyStart":"1","redirectTime":"0","appcacheTime":"0","unloadEventTime":"14","lookupDomainTime":"0","connectTime":"0","requestTime":"878","initDomTreeTime":"1008","loadEventTime":"2","navigationStart":"1426401215594","unloadEventStart":"1426401217150","unloadEventEnd":"1426401217164","redirectStart":"1426401215595","redirectEnd":"1426401215595","fetchStart":"1426401215595","domainLookupStart":"1426401215595","domainLookupEnd":"1426401215595","connectStart":"1426401215595","connectEnd":"1426401215595","requestStart":"1426401216271","responseStart":"1426401216041","responseEnd":"1426401217149","domLoading":"1426401217150","domInteractive":"1426401218157","domContentLoadedEventStart":"1426401218158","domContentLoadedEventEnd":"1426401218197","domComplete":"1426401219812","loadEventStart":"1426401219812","loadEventEnd":"1426401219814"},"url":"/events"} user=wadus company=chaflan
```
{% endhighlight %}

But you may think that logging more requests events can modify our existing backend metrics, that's why the engine allows to disable the NewRelic tracking of the requests that it process. Besides our logstash configuration doesn't count those requests as normal request instead it considers them as stats requests and populate other unrelated librato metrics.

The Real User Measurement doesn't end on page load events we extended the behaviour to track AJAX requests timings from the user point of view, we track [PJAX](https://github.com/defunkt/jquery-pjax) and [turbolinks](https://github.com/rails/turbolinks) also. For these kind of interactions we store the referer of the interaction, how much time the interaction spent and the url where it makes the request and we namespace that information by kind of interaction so configuring logstash properly we can modify only the related metrics of each interaction. To properly measure the time that interaction spent we use the [User Timing API](http://www.w3.org/TR/user-timing/) through the following polyfill [usertiming.js](https://github.com/nicjansma/usertiming.js). For example:

{% highlight js %}
function trackInteraction(type, interactionData)
  var data = {},
    url = '/_stats', // where you mounted the engine
    request = new XMLHttpRequest();

  // {pjax: {url: '/users?page=2', referer: '/users', ms: 320}}
  data[type] = interactionData;

  request.open('POST', url, true);
  request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
  request.send(data);
}, false);
{% endhighlight %}

Think that you like to measure in average how much time spent your turbolink enhanced page as the user experimenced that interaction or when paginate through AJAX a list of one of your business models, with this engine and our existing infrastructure we answer this question easily and as we already used librato our retention is much more bigger than we need to check how we improve or decline the apps performance.

So to start to improving your application you first need to measure what you want to improve as you see we already did it.



