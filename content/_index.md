---
title: VerifyThis Competition 
---

# VerifyThis Competitions and Long Term Challenges

The *VerifyThis Verification Competition* is a recurring event run as
an onsite meeting with workshop character in which three challenges
are proposed that participants have to verify in 90 minutes each using
their favourite program verification tool.

The *VerifyThis Long Term Challenge* was established as a complement
to the short-term competitive challgenges. Here, verification tasks
are addressed collaboratively, without the constraints of time
pressure.

<style>
.pure-g {
	display:grid; 
	grid-template-columns: 50% 50%;
}
.pure-g div { 
	padding: 1ex;
	/* filter: saturate(.3); */
}
.pure-g div.onsite {
    background: var(--onsite);
    padding: 20px;
}
div.ltc {
    background: var(--ltc);
    padding: 20px;
}
a.button {
    border: 2px solid black;
    border-radius: 5px;
    padding: 5px 20px;
    background: rgba(255,255,255,.5);
}
a:hover.button {
    background: rgba(255,255,255,.8) !important; 
}
.pure-g h2 {
    text-align: center;
}
</style>


{{% columns %}}
{{% column class="onsite" %}}

## <a href="onsite" class="button">Visit VerifyThis@ETAPS</a>

VerifyThis is a series of program verification competitions, which has
taken place annually since 2011 (with the exception of 2020). Previous
competitions in the series have been held at FoVeOOS 2011, FM 2012,
Dagstuhl (April 2014), and ETAPS 2015---2025.

The aims of the competition are:

-   to bring together those interested in formal verification, and to
    provide an engaging, hands-on, and fun opportunity for discussion.
-   to evaluate the usability of program verification techniques and
    tools.

The competition offers a number of challenges presented in natural
language and pseudo code. Participants have to formalize the
requirements, implement a solution, and formally verify the
implementation for adherence to the specification.

There are no restrictions on the programming language and
verification technology used. The correctness properties posed in
problems will have the input-output behavior of programs in focus.
Solutions will be judged for correctness, completeness, and elegance. 
{{% /column %}}

{{% column class="ltc" %}}
## <a href="ltc" class="button">Visit VerifyThis LTC</a>

The **VerifyThis Long-Term Challenge** aims at proving that deductive
program verification can produce relevant results for real systems
with acceptable effort on a large scale in a collaborative manner.

The current challenge is dedicated [memcached](/ltc/03memcached), a simple
LRU-cache based key-value server. Memcached is the backbone for fast
response times in distributed web-application. The goal is not only to
provide an investigation on the server alone, but also take the
client-side and the protocol into our considerations.
{{% /column  %}}
{{% /columns %}}
