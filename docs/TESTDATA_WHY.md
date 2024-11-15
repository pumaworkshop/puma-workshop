# On making your own test data with Puma

<!-- TOC -->
* [On making your own test data with Puma](#on-making-your-own-test-data-with-puma)
  * [Why make your own test data?](#why-make-your-own-test-data)
    * [Ground truth](#ground-truth)
    * [Completeness](#completeness)
    * [The GDPR (or similar privacy legislation)](#the-gdpr-or-similar-privacy-legislation)
    * [Exotic applications](#exotic-applications)
  * [Using Puma vs creating test data manually](#using-puma-vs-creating-test-data-manually)
<!-- TOC -->

Puma was created at the NFI to improve our process of creating test and reference datasets. Before you do the same, it's
good to ask yourself whether you want to make your own test data, and whether you want to use Puma to do this.

## Why make your own test data?

Before we get into making test data, let's focus on whether you actually want to do so. After all: if you want some
reference data on specific apps, you'll probably find some example files online with a quick Google search. Well,
there's a few reasons why we at the NFI prefer to make our own datasets:

### Ground truth

Say for example you have a populated chat database you found online or got from some device, and you have a bunch of
messages with a timestamp: how are you going to find out what that timestamp is? Is it the time the message was sent,
received, or read? And was it the server time or the device time? And what if you cannot find any pictures in the
database, does that mean this chat app doesn't store pictures in the database, or that you just happened to find a
database of a user that has never sent or received a picture?

When you create your own test data, you know which actions exactly were taken, which makes it much easier to figure out
what your data means.

### Completeness

Say you ignore the last point, and you are convinced you will be able to figure out what the data means exactly, but now
you notice that there isn't a single picture in the database. Now you have to go back to searching the internet for
another database with pictures. That probably isn't too hard, pictures after all are pretty common. So let's say you do
find a second database file containing pictures.

But what about group chats? What about people being removed from a group chat or leaving by themselves? What about
pictures that can be viewed once but haven't been opened yet? What changed avatars on the public profile?

These are just examples of chat applications, but the same holds true for all other types of apps: with ever-expanding
features of applications it becomes virtually impossible to find organic user data that contains all possible user
actions. Or, more specifically, all user actions of interest to your project you want to create reference data for.

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

## Using Puma vs. creating test data manually

If you have decided to create your own test data, you can still decide to make manually make the data, or to automate
the proces. You might think that, since this is Puma documentation, we would advocate to always automate the process,
but we actually don't!

Puma requires app-specific code to be able to interact with the UI of a specific application, and while adding support
for your app isn't very difficult (we've written [a guide helping you in this process](../CONTRIBUTING.md)) it does take
time that you could also spend on manually creating reference data.

When deciding whether to use Puma, consider the following:

* Does Puma already support your application?
* Are you planning to create the reference data multiple times? (e.g. on different phones, OS versions, or app versions)
* Are you creating a large amount of data (eg 100+ messages)?

If the answer to any of these questions is yes, our experience is that Puma will save you time.

If Puma doesn't support your app, and this is a one-time thing, and you're doing only a dozen or so user actions, we
recommend making the test data manually.
