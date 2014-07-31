# Stream - An App.net client

This is just an iOS coding exercise, first step of an interview process.

[![Build Status](https://travis-ci.org/mokagio/Stream.svg?branch=master)](https://travis-ci.org/mokagio/Stream)

## The Spec

Write an App.net client to display posts from users. The app should present posts in a
table with all of name, handle, avatar, content and age of post visible. 

The number of posts that can be viewed should be infinite; if the user scrolls to the bottom of the list of posts, get and display more. 

_**Bonus Task**_: If a URL is present in the post content, tapping it should open that URL.

### About the Spec

This looks like a rather simple assignment, with a couple of things to verify first:

* How user friendly the App.net APIs are
* How _pagination_ friendly the App.net APIs are
* Is there an easy way to detect links within a `UILabel` and make the interactive?

### A quick look at the App.net APIs

From the spec we gather that what we need from the [App.net APIs](https://developers.app.net/reference/) is just the endpoint to get a list of all posts. Usually this kind of services don't require authentication for a request of this type, wich is good because it would speedup the development.

As hoped there is a `GET` endpoint that doesn't require authentication to retrive _the most recent Posts from the Global stream_. [`/posts/stream/global`](https://developers.app.net/reference/resources/post/streams/#retrieve-the-global-stream).

The endpoint is also [paginated](https://developers.app.net/reference/make-request/pagination/), which is exactly what we need to implement the "load more" feature.

### How to detect links withing the text of a `UILabel`

That seems like a Regexp job to me, but how to make only that piece of text interactive? Maybe using a well placed subview? Or hacking around with the touchable area? 

Wonder no more! There is a pod for that: [TTTAttributedLabel](https://github.com/mattt/TTTAttributedLabel#links-and-data-detection) does this for free, plus another number of useful things.

## The Roadmap

Now that some of the tricky bits of the implementation are more clear to me we can lay down a battle plan.

1. Walking skeleton that loads a finite number of posts from the server, showing only the title.
2. Complete display of the posts data
3. Load more feature
4. Minimal network error handling
5. A bit of UI
6. Interactive links

### Tech choices

App.net seems to have an [iOS (+ Android) SDK that we could use to load the posts](https://github.com/appdotnet/ADNKit/blob/master/ADNKit/ANKClient%2BANKPostStreams.h#L20), but this would result in me using very little of my own coding, and take away all the fun.

We'll need to make requests to the App.net server. To do this I want to use on AFNetworking. It's simple, robust and well tested. Even if it might seem as an overhead for just a couple of requests, I love the API and it's gonna kickstart my network layer.

AFNetworking also provides the `AFURLResponseSerialization` protocol that we could use to write a custom serializer from the JSON response to our model objects. I am not gonna use this, preffering to write the parsing myself. This way an eventual _unplug_ of AFNetworking would be simpler. This also allows me to _show off_ my approach to testing application logic.

As my testing framework, or better stack, I'm gonna use [Specta](https://github.com/specta/specta). I prefer this to XCTest because of the better syntax it has.

I'm gonna do all my views in code. This is probably a controversial topic. My reasons for this are that I don't like all the clicking overhead that IB adds, I don't like to have to check different tabs to fully understand the settings of my views, and I don't like to read XML diffs to see what's changed.

## The development

[This blog post](http://mislav.uniqpath.com/2014/02/hidden-documentation/) I read some time ago inspired me on how to use git to provide extra documentation to the project and it's development. All the details and reasoings behind my implementation can be found in the messages of the commits.

---

## Wrapping things up

This exercise has been quite fun. I clearly underestimated the complexity of the autoresizing table view cells with AutoLayout, as usual.

The desire to experiment and _show off_ different approaches probably resulted in a codebase not completely consistent, but still in my opinion well structured.

There are some where to go next points form here, code wise:

* Remove AFNetworking completely and just rely on `NSURLSession` **or**
* Push the use of AFNetworking further on with a custom response serializer **or**
* Use the App.net SDK
* Use IB for the views rather than the code
* Group the colors under a palette category to simplify changes
* Drop the DateTools pod and implement custom _timeago_ feature
* Profile the performances

From the app point of view interesting developement could be:

* Add a pull to refresh
* Provide a "Load more" button to load more posts, rather than doing it automatically. This would make it less _network hungry_
* Allow the user to set the number of posts to download per request, since the APIs allow that.

---

2014 - Giovanni Lodi