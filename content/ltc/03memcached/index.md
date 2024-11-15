---
title: "Memcached: VerifyThis Long-term Challenge"
subtitle: Specifying and Verifying a Real-life Remote Key-Value Cache
---

We propose the **second VerifyThis long-term challenge**: A verified
drop-in replacement of the in-memory key-value cache
[`memcached`](https://memcached.org/). Software like `memcached` is
the backbone for fast response in cloud-native environment by storing
and caching *hot* information. This particular software package is
open source (BSD 3 clause license) and it is widely in use at major
players like Google, Amazon, Microsoft, Facebook, and Twitter.

At the same time, much of the complexity of `memcached` is internal,
i.e., its external interface is fairly straight-forward, which means
that developing a (verified) drop-in replacement that supports a
compatible subset of the protocol requires a reasonably low effort only.

## {{< awesome fas fa-bullseye >}} Goals
The overarching goals and research directions of this long-term
challenge are as follows:

{{% columns %}}
{{% column %}}
* Develop high-level behavioral models and contract specifications
that abstractly capture the core functionality of a remote cache
server, the protocol, and the client library

* Characterize global properties of the entire system, e.g. temporal
liveness and safety properties related to the lifecycle of cache
entries

{{% /column %}}
{{% column %}}
* Design and verify an implementation that realizes these requirements
and that may serve as a drop-in replacement for `memcached` with
support of a significant subset of its features
    
* Verify parts of the actual `memcached` implementation (written in
C), using e.g. scalable software model checking methods or focused
deductive techniques on critical routines
{{% /column %}}
{{% /columns %}}

We emphasize that the challenges associated with these respective
goals can be scaled in many dimensions (realistic interfaces,
algorithms and data structures, features). It is therefore *easy to
get started*, in fact, we provide two abstract but reasonably complete
executable reference implementations that should help with the first
steps.


#  {{< awesome fas fa-pencil-alt >}} System Description

`memcached` is an in-memory key-value store that acts as a cache. It
offers operations to enter keys into the cache data structure with
associated values and also a timeout for which the association is
valid. In contrast to traditional databases, entries can implicitly be
evicted from the cache due to memory pressure, which `memcached`
resolves by a LRU protocol. The architecture of the main `memcached`
application is that of a server which serves requests to clients by
spawning multiple threads, which in turn access the shared internal
data structure. The standard interface is a simple text and line-based
over telnet with a small set of commands that include lookup, update,
and also (atomic) replacement. `memcached` is supposed to serve
multiple front-end applications at a time. Typically, `memcached` is
used via a client library interface which offers a high-level API.
Such libraries exist for a variety of programming languages (including
Javascript and PHP). Besides setting up the telnet connection and
realizing the simple communication protocol, client libraries may also
support load-balancing queries over a pool of `memcached` servers,
such that each server is made responsible for a subset of the keyspace
in use by the application.


![](arch.svg)
{.a style="background:#bbb;padding:1ex"}

## Resources

Please feel free to use the following resources to familiarize yourself
with the functionality and internals of the `memcached` server and its
behavior. Note that both implementations may be incomplete and/or not
entirely be faithful to the reference `memcached`. If you spot such a
difference that is not documented please contact the respective author
or file a github issue.

-   A great description of the internals is this video by Hussein
    Nasser:  `memcached` is <https://www.youtube.com/watch?v=NCePGsRZFus>

-   High-level executable Python model and implementation (Gidon
    Ernst): <https://github.com/gernst/pycached>

-   Java implementation (protocol, main functionality, Alexander
    Weigl): <https://github.com/wadoon/bloatcache>

