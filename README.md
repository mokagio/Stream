# Stream - An App.net client

This is just an iOS coding exercise, first step of an interview process.

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