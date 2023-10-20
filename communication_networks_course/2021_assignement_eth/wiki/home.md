In this wiki you can find everything about the mini-Internet project,
which is part of the [Communication Networks Course](https://comm-net.ethz.ch/) at ETH taught by Prof. Laurent Vanbever
from the [Networked Systems Group](https://nsg.ee.ethz.ch/).

## Introduction to the project

In this project, you will build and operate your very own mini-Internet 
together with more than 100 of your fellow classmates. Your main goal? Enabling
end-to-end connectivity across around 70 Autonomous Systems (ASes) composed
of hundreds of network devices. In doing so, you will experiment with the most
common switching and routing technologies used in the Internet today. You will
also face the same challenges actual network operators experience every day.

To reach Internet-wide connectivity, you will first need to enable internal
connectivity, **within** your own AS, before interconnecting your AS with
other ASes, managed by other groups of students. To establish connectivity
**within** your AS, you will configure IPv4 and IPv6 addresses and use Open
Shortest Path First (OSPF). To establish connectivity **across** different
ASes, you will use the only inter-domain routing protocol available today: the
Border Gateway Protocol (BGP). At the end of the project, end-hosts should
be able to communicate with each other, independently of the AS they are
located in.

To help you, we have pre-built a base network topology on top of virtual
layer-2 switches, running [Open vSwitch](https://www.openvswitch.org/) and
virtual routers, running the [FRRouting software routing suite](https://frrouting.org/).
You will configure the virtual switches and routers through a Command Line Interface (CLI).
This interface is virtually identical to the one used by actual network operators.

## Table of contents

This wiki consists of three main parts, an assignment, a tutorial and a FAQ section. The assignment section contains:

- [General instructions](../1.-Assignment/1.1-General-Instructions) about the project, including **submission instructions**.
- [An overview](../1.-Assignment/1.2-Your-mini-Internet) of the mini-Internet and the network you will configure.
- [The tasks you need to solve](../1.-Assignment/1.3-Questions) and what to include in your final report.
- [The tools to help](../1.-Assignment/1.4-Tools-to-help-you) you testing and verifying your configuration.

The tutorial section explains how to:

- [Access your devices](../2.-Tutorial/2.1-Accessing-your-devices) such as routers, switches and hosts.
- [Configure a host](../2.-Tutorial/2.2-Configuring-a-host) to e.g., give it an IP address.
- [Configure an Open vSwitch](../2.-Tutorial/2.3-Configuring-Open-vSwitch) to enable layer 2 connectivity.
- [Configure 6in4 tunnels](../2.-Tutorial/2.4-Configure-6in4-tunnels) to allow IPv6 traffic to be forwarded over an IPv4 network.
- Configure IP routers to establish layer 3 connectivity within one AS and between ASes. More precisely, the tutorial covers:
   * [The FRRouting CLI](../2.-Tutorial/2.5-Configuring-IP-routers/2.5.1-The-FRRouting-CLI) which you use to configure the routers.
   * [Interface configuration](../2.-Tutorial/2.5-Configuring-IP-routers/2.5.2-Configuring-router-interfaces), e.g. how you can configure IP addresses.
   * [Static route configuration](../2.-Tutorial/2.5-Configuring-IP-routers/2.5.3-Configure-static-routes) to precisely steer the forwarding behavior of certain traffic.
   * [OSPF configuration](../2.-Tutorial/2.5-Configuring-IP-routers/2.5.4-Configure-OSPF) to establish connectivity within your AS.
   * [BGP configuration](../2.-Tutorial/2.5-Configuring-IP-routers/2.5.5-Configure-BGP) to establish connectivity between different ASes.
   * [BGP policies](../2.-Tutorial/2.5-Configuring-IP-routers/2.5.6-Configure-BGP-policies) to give you more control over how the traffic is forwarded inside your AS.
- [VPN configuration](../2.-Tutorial/2.6-VPN-configuration) to show you how to access the mini-Internet over a VPN connection (for the bonus question).

Finally we have a [list of frequently asked questions](../3.-Frequently-Asked-Questions) that we will also continue to update during the project.


## Additional useful links

In addition, the following links will be useful during the project. We also refer to them later in the description of the tasks and tools.

- [AS connections](https://comm-net.ethz.ch/routing_project/as_connections): The list of the interconnections between the different ASes.
- [Connectivity matrix](http://comm-net.ethz.ch/routing_project/matrix/matrix.html): A connectivity matrix that will tell you with whom you can communicate.
- [BGP looking glass](http://comm-net.ethz.ch/routing_project/looking_glass/G1/NEWY.txt): A service to see the routing table of every router.
- [BGP policy analyzer](https://comm-net.ethz.ch/routing_project/bgp_analyzer/analysis.html): An almost real time BGP policy analyzer that detects and prints (most, but not all) route leaks for every AS.
