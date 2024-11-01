# Guidelines for creating test data

At the NFI we have been making reference data for some time now, and through the years we discovered some best practices
improving our process but also the quality of the test data itself. If you are also using Puma to create reference or
test data, this document will help you to create your datasets better and faster.

## 0. Why make your own test data?

Before we get into making test data, let's focus on whether you actually want to do so. After all: if you want some
reference data on specific apps, you'll probably find some example files online with a quick Google search. Well,
there's a few reasons why we at the NFI prefer to make our own datasets:

### Ground truth

Say for example you have a populated chat database you found online or got from some device, and you have a bunch of
messages with a timestamp: how are you going to find out what that timestamp is? Is it the time the message was sent,
received, or read? And was it the server time or the device time? And what if you cannot find any pictures in the
database, does that mean this chat app doesn't store pictures in the database, or that you just happened to find a
database of a user that ahs never sent or received a picture?

When you create your own test data you know which actions exactly were taken, which makes it much easier to figure out
what your data means.

### Completeness

Say you ignore the last point, and you are convinced you will be able to figure out what the data means exactly, but now
you notice that there isn't a single picture in the database. Now you have to go back to searching the internet for
another database with pictures. THat probably isn't too hard, pictures after all are pretty common. So you find that.

But what about group chats? What about people being removed from a group chat or leaving by themselves? What about
pictures that can be viewed once but haven't been opened yet? What changed avatars on the public profile?

These are jsut examples of chat applications, but the same holds true for all other types of apps: with ever-expanding
features of applications it becomes virtually impossible to find organic user data that contains all possible user
actions. Or, more specific, all user actions of interest to your project you want to create reference data for.

If you create your own test data you can be sure it covers all relevant user actions for your use case.

### The GDPR (or similar privacy legislation)

Using data you found online might be easy and good enough for your use case, but if it contains personal data using that
data is probably illegal under the GDPR, or at the very least a possible problem.

When you create your own test data with dummy accounts, you can rest assured there won't be any problems, as you're not
using real personal data.

⚠️ Be careful even when creating your own data! Some applications will automatically store data from other users (for
example public chat channels or "users nearby" features). If these features are included in your apps, you may still
need consider the GDPR.

### Exotic applications

Lastly, the most obvious point: some applications simply aren't that common, so finding data from them online or from
other sources is not an option.

## 1. Plan ahead

Now that you're convinced to create your own test data, let's get to it. The first step is careful planning. You might
be tempted to just start sending messages or start browsing in the app you want to generate reference data for, but from
experience we learned creating test data is something best properly planned ahead.

## 2.