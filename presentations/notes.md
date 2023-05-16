
Before we jump into the definitions,
I would like you all to think,
for a brief moment, in a couple
of scenarios:

How would Joe Biden prove the
authenticity of his wonderful
review of Heaven Pizzeria?
Or the Pope after buying that 
brand new fancy jacket?
How would a reporter certify
the autheticity of his media content
covering an important event?
Or a service provider proving 
the delivery or supply of goods 
at a certain location?
How can I prove to someone else later
that I was here in this room 
before you and at this moment in time, 
defending my thesis?

These are part of the set 
of today's problems
the typical GPS-based 
location systems,
mapping platforms, 
or mobility and ride-hailing apps
do not provide straight answers for.
With this present surge of highly 
realistic generative AI tools,
what we may need instead is 
a paradigm shift,
towards digital Proofs of Location.

---------------------------

These proofs are nothing more profound
than electronic certificates that
attest one's position 
in both space and time.

To get such proofs,
some arrangements between 
different types of entities
should be put in place.

Typically,
these location-proof setups 
expect the existence of a prover 
that engages in any communication 
protocol with nearby participants,
the witnesses, with the goal of 
gathering a verifiable 
Proof-of-Location claim, to be later
presented to a verifier, 
therefore convincing it of one’s 
existence within a geographical
area, at a given moment.

In this thesis, we started by
dissecting this 
Proof-of-Location systems' paradigm
And did as well a review of 
the state of the art.
Starting from centralized and trusted solutions 
where trusted entities would interact
via short range communication
and provide verified space and time claims
to each other,
we advanced towards decentralized and 
infrastructure-independent approaches. 
The distribution of trust, resources,
power, and fault-tolerance has driven 
the development of modern protocols, 
culminating in the need for not only
short-range communication but also
decentralized time synchronization.
To leave you with some thoughts
How could we all agree to be 
here in this room, now,
if our clocks were not synchronized
and marking a similar time?

These are the main ideas behind most
Proof-of-Location protocols, 
which are generally considered secure if 
complete, meaning, 
containing space and time witnessing references,
spatio-temporally sound, or in other words,
if it's very hard for the prover to get a valid
proof if not physically present 
at that specific location and time,
and non-transferable, meaning,
valid only for that prover.

--------------------------------------------

Having identified this need for both
space and time synchronization,
our second set of contributions
was the design of a novel decentralized
Proof-of-Location protocol and 
the implementation of a proof-of-concept
that could cover the entire range of requirements
and be able to generate 
complete, verifiable, and spatio-temporally sound
location-proofs.

--------------------------------------------

The journey started with the identification
of a suitable network topology to meet the 
requirements of space synchronization.
The perfect fit was the concept of dynamic and 
non-hierarchic mesh networks. 
These topologies enable the 
short ranged and peer-to-peer
communication between the nodes
in a decentralized fashion, with no
central coordinating devices, 
and they are also known for their ability 
to self-organize and dynamically adapt 
to changes in the topology.

The transmission of data starts, of course,
in the physical layer, with the arrangements
of the devices and their physical connectors.

And the topology finally gains form with 
layer 2 routing protocols that determine 
the best path for data packets to travel through.
These algorithms coordinate the processes of discovering
nearby nodes and the ranking of their links, first,
for optimizing communication paths, reducing congestion, 
and increasing the overall efficiency of the network.
And second, for the targeted establishment of zones within 
the mesh network. Zones are strongly connected sets of
neighbours, that, in the case of our Proof-of-Location
protocol, will be specifically used to provide witnessing capabilities.

--------------------------------------------

This first part of the protocol design
was then implemented in the proof-of-concept
by making use of a set of different technologies.
Since it is a good fit for resource constrained devices,
We chose OpenWRT as the operating system 
running on each node.
Our initial goal was to actually 
deploy the protocol in physical devices
but to ease and speed up the development, 
we used QEMU to emulate the environment.
And finally, batman-adv was the chosen layer 2 routing protocol
for enabling mesh network capabilities.

The testbed has a set of witnesses and a prover instance,
all connected to a bridge interface that is supposed to
pool all the raw mesh traffic, simulating the physical medium.
Jumping to the 2 layer, the data link layer, 
we assigned MAC addresses to the interfaces and set up batman-adv
for the discovery of neighbours, peer-to-peer connections,
and the eventual formation of a witnessing zone.
Next, we took advantage of the typical TCP/IP suite of protocols
and by subnetting, within the zone, we finally enabled 
the typical internet connections that we all know how to work with.
The final network architecture looks like the figure on the right
and is ready to see deployed any web service, 
abstracted from the underlying and
strongly connected mesh topology.

Assuming these connections happen through some 
short-range communication channel,
with this effort we have achieved the first step
of space synchronization between all the entities of the protocol.

A quick analogy for you to think about
is the fact that we are all here and limit
our physical interactions to this room.
We can talk to each other directly, 
but not with anyone outside or 
someone who is very far away.

--------------------------------------------

Now, the missing part is 
to synchronize the witnesses clocks.
This need was identified in the most recent
decentralized protocols and the problem has been
solved with a Bizantine fault-tolerant 
clock synchronization mechanism.
We have looked into it and reasoned about the
similarities between such mechanisms 
and the problem of consensus in distributed systems.
In simple terms, synchronizing clocks is nothing 
more than reaching agreement about the 
current time of the internal clocks of a 
distributed setting of machines.
This agreement can be extended to reach consensus
about the current state of the system,
And our unique contribution relies exactly on the employment
of a consensus mechanism to make witnesses agree
to pace the zone events at the same rate, and so,
achieve consensus and establish zone-relative time consciousness.
This eventually allows for a strongly consistent serialization
of transactions and total order of multidimensional events,
instead of the old way of simply counting time 
in a unidimensional manner.

Since we assumed a trustless environemnt, 
this can be transposed to the problem of achieving
permissionless consensus, 
fulfilling the need for ordering 
and synchronizing events, 
at the same pace, in an environment 
where individual participants are not 
necessarily trusted.

Additionally
The potential turing completeness 
of such consensus mechanism
may allow for a network of nodes to 
perform arbitrary computations in a
decentralized and fault-tolerant manner.
It could essentially enable the creation of
smart contracts, as self-executing code agreements 
that are dictated by the terms of the direct consensus 
between the entities that are involved in
the Proof-of-Location protocol.
One could now, for example, attest multiple provers,
or enforce the location attestation at a specific block or time.

--------------------------------------------

The way we solved this, in practical terms,
was via the deployment of a blockchain network
within the zone.
We chose Ethereum as the blockchain framework
and experimented with the available consensus protocols
playing around with the block time,
the interval between blocks.
We've configured the network via the genesis file,
and building on the mesh network infrastructure we just set up,
the ethereum nodes were able to discover eachother
via the exposed API endpoints,
and start producing blocks, achieving time synchronization.

In this example, we chose the Proof-of-Authority mechanism
and a block time of 10 seconds.

The decision around Ethereum had also the purpose of enabling
the execution of smart contracts, programmed in Solidity
and executed by the Ethereum Virtual Machine.

The whole process was automated with a set of utility tools
that we coded to help us easily boot up an ad-hoc ethereum network
within the mesh.
And all the software that we produced and compiled
plus all the packages needed to achieve all these steps
of space and time synchronization were all embeded 
into the OpenWRT image and made available independently
to each node.

--------------------------------------------

With the witnesses synchronized in space and time
The prover can now take advantage of this synchrony
to finally produce a verifiable proof of location.

This diagram shows the proof generation process
conducted by the prover.
Assuming the prover is communicating with the witnesses
via the same short ranged communication means
The prover needs as well to prove it is synchronized 
with the zone's clock.

So the prover needs to learn about the most recent block;
Assemble, sign, and submit a transaction 
containing the hash of that most recent block;
Wait for the witnesses to validate the transaction
and include it in the next block;
And finally get the witnesses signatures
over that block that contains the prover's transaction.
All these signatures can then be part of the certificate
to be submitted later to a verifier.

The verification process is like any
typical digital signature verification
that should just verify the integrity and autheticity 
of the signed data.

This whole process ensures spacial synchronization
with the enforcement of a short-ranged communication means,
temporal alignment 
of the prover with the zone-relative time tx+1
and authenticity of the location data, 
via the use of digital signatures.

For the proof-of-concept,
we showcased and automated both 
the generation and verification processes
via smart contracts, 
that can, but not exclusively,
achieve this very same execution flow, 
in a decentralized and trustless way.

--------------------------------------------

At the end, we also conducted some measurements
to understand the behaviour and performance of our system.
Since our protocol was fundamentally new and different 
from all the others, we could not establish a fair comparison,
but we still measured, for example, some performance factors
at the mesh network level and at the blockchain level.

We noticed a seemingly linear increase 
of the average protocol throughtput of both
the batman frames and IPv4 related packets,
with the increase in the number of witnesses.
We also observed the blockchain behaviour
and noticed a fairly small network overhead
with some ocasional peaks of TCP traffic 
during the block proposal phases, 
matching the expected block time.

We measured, as well, CPU, RAM and Disk usages
and observed very low resource consumption,
demonstrating the adaptability and suitability
of such protocol for resource constrained environments.

Additionally, 
We decided to conduct some tests
to measure the relation between the success rate,
in generating valid certificates,
and the block time.
Essentially, a more permissive block time
allows for a larger success rate, 
but opens the possibility
for what we identified as proxy attacks.
When an adversary has enough time
to fetch the latest block, ask a remote prover for a signature
and submit a transaction.
We concluded so that the block time
plays a crucial role in the soundness of the protocol
and needs to be adjusted carefully
to help battle this set of attacks.

--------------------------------------------

To conclude,
In this thesis
We dissected the Proof-of-Location paradigm,
identifying the entities, their interactions, 
and some real world applications.

We reviewed the state of the art,
from trusted and centralized systems
towards distributed and decentralized setups.

We specified a novel decentralized protocol
for the achievement of space and time synchronization

And implemented and evaluated a proof of concept
making use of mesh technologies and permissionless consensus mechanisms.

For the future,
There is still a lot of work to do.
Incentive mechanisms for the creation 
and expansion of this witnessing zones
Evaluating other consensus protocols,
Making full use of the smart contracts capabilities
Employing privacy preserving mechanisms
like zero knowledge proofs
And of course the Physical Deployment
And the evaluation of the
performance in real-world settings.

