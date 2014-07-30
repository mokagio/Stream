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