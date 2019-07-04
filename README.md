# The Enterprise Onion Toolkit
![banner image](docs.d/hello-onion-text.png)

## Primary Supported Platforms

* Ubuntu 18.04LTS, Latest Updates
* OSX Mojave with Homebrew, Latest Updates
* Raspbian Stretch/Stretch-Lite, Latest Updates

## Maillist / Group

General discussion mailllist: deployment, tweaks and tuning:

* mailto:eotk-users+subscribe@googlegroups.com (via email)
* https://groups.google.com/group/eotk-users/subscribe (via web)

NB: bugs should be reported through `Issues`, above.

### In the News

* Jan 2018 [Volunteer Spotlight: Alec Helps Companies Activate Onion Services
](https://blog.torproject.org/volunteer-spotlight-alec-helps-companies-activate-onion-services)
* Nov 2017 [Un service Wikipedia pour le Dark Web a été lancé par un ingénieur en sécurité](https://www.developpez.com/actu/175523/Un-service-Wikipedia-pour-le-Dark-Web-a-ete-lance-par-un-ingenieur-en-securite-afin-de-contourner-la-censure-dans-certains-pays/)
* Nov 2017 [Δημιουργήθηκε σκοτεινή έκδοση της Βικιπαίδειας για ανθρώπους σε λογοκριμένα καθεστώτα](https://texnologia.net/dhmiourgithike-skoteinh-ekdosh-ths-wikipedia-gia-anthropous-se-logokrimena-kathestota/2017/11)
* Nov 2017 [A security expert built an unofficial Wikipedia for the dark web](https://www.engadget.com/2017/11/25/a-security-expert-built-an-unofficial-wikipedia-for-the-dark-web/)
* Nov 2017 [There’s Now a Dark Web Version of Wikipedia](https://motherboard.vice.com/en_us/article/7x4g4b/theres-now-a-dark-web-version-of-wikipedia-tor-alec-muffett)
* Oct 2017 [The New York Times is Now Available as a Tor Onion Service](https://open.nytimes.com/https-open-nytimes-com-the-new-york-times-as-a-tor-onion-service-e0d0b67b7482)
* Apr 2017 [This Company Will Create Your Own Tor Hidden Service](https://motherboard.vice.com/en_us/article/this-company-will-create-your-own-tor-hidden-service)
* Feb 2017 [New Tool Takes Mere Minutes to Create Dark Web Version of Any Site](https://motherboard.vice.com/en_us/article/new-tool-takes-mere-minutes-to-create-dark-web-version-of-any-site)

## Introduction

EOTK provides a tool for deploying HTTP and HTTPS onion sites to
provide official onion-networking presences for popular websites.

The result is essentially a "man in the middle" proxy; you should set
them up only for your own sites, or for sites which do not require
login credentials of any kind.

## EOTK and HTTPS

When connecting to the resulting onions over HTTP/SSL, you will be
using wildcard self-signed SSL certificates - you *will* encounter
many "broken links" which are due to the SSL certificate not being
valid.

This is *expected* and *proper* behaviour; there are currently two
ways to address this.

## install `mkcert`

The *best* solution for development purposes is to [install `mkcert`
onto the machine which will be running
EOTK](https://github.com/FiloSottile/mkcert#installation) and
configure your own personal Certificate Authority for the certificates
that you will need.

You can then add `set ssl_mkcert 1` to configurations, and your
`mkcert` root certificate will be used to sign the resulting onion
certificates.


## visit `/hello-onion/` URLs

The old solution was/is much more manual: for any onion - eg:
www.a2s3c4d5e6f7g8h9.onion - EOTK provides a fixed url:

* `https://www.a2s3c4d5e6f7g8h9.onion/hello-onion/`

...which (`/hello-onion/`) is internally served by the NGINX proxy and
provides a stable, fixed URL for SSL certificate acceptance; inside
TorBrowser another effective solution is to open all the broken links,
images and resources "in a new Tab" and accept the certificate there.

In production, of course, one would expect to use an SSL EV
certificate to provide identity and assurance to an onion site,
rendering these issues moot.

## Installation

Please refer to the [How To Install](docs.d/HOW-TO-INSTALL.md) guide

## Help I'm Stuck!

Ping @alecmuffett on Twitter, or log an `Issue`, above.

## Important Note About Anonymity

The presumed use-case of EOTK is that you have an already-public
website and you wish to give it a corresponding Onion address.

A lot of people mistakenly believe that Tor Onion Networking is "all
about anonymity" - which is incorrect, since it also includes:

* extra privacy
* identity/surety of to whom you are connected
* freedom from oversight/network surveillance
* anti-blocking, and...
* enhanced integrity/tamperproofing

...none of which are the same as "anonymity", but all of which are
valuable qualities to add to communications.

Further: setting up an Onion address can provide less contention, more
speed & more bandwidth to people accessing your site than they would
get by using Tor "Exit Nodes".

If you set up EOTK in its intended mode then your resulting site is
almost certainly not going to be anonymous; for one thing your brand
name (etc) will likely be plastered all over it.

If you want to set up a server which includes anonymity **as well as**
all of the aforementioned qualities, you [want to be reading an
entirely different document,
instead](https://github.com/alecmuffett/the-onion-diaries/blob/master/basic-production-onion-server.md).

## Acknowledgements

EOTK stands largely on the experience of work I led at Facebook to
create `www.facebookcorewwwi.onion`, but it owes a *huge* debt to
[Mike Tigas](https://github.com/mtigas)'s work at ProPublica to put
their site into Onionspace through using NGINX as a rewriting proxy --
and that [he wrote the whole experience up in great
detail](https://www.propublica.org/nerds/item/a-more-secure-and-anonymous-propublica-using-tor-hidden-services)
including [sample config
files](https://gist.github.com/mtigas/9a7425dfdacda15790b2).

Reading this prodded me to learn about NGINX and then aim to shrink &
genericise the solution; so thanks, Mike!

Also, thanks go to Christopher Weatherhead for acting as a local NGINX
*sounding board* :-)

And back in history: Michal Nánási, Matt Jones, Trevor Pottinger and
the rest of the FB-over-Tor team.  Hugs.
