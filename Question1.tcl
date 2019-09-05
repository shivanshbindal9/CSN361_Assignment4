 #Create a simulator object
set ns [new Simulator]

#Routing Protocol used is Distance Vector
$ns rtproto DV

set nf [open q1.nam w]
set f [open q1.tr w]

$ns namtrace-all $nf
$ns trace-all $f

proc end {} {
    global ns nf f
    $ns flush-trace
    close $nf
    close $f
    exec nam q1.nam
    exit 0
}

# Create the network nodes
set node1 [$ns node]
set node2 [$ns node]
set node3 [$ns node]

$node1 color blue
$node2 color orange
$node3 color green

#Create links between the nodes
$ns duplex-link $node1 $node2 1Mb 10ms DropTail
$ns duplex-link $node2 $node3 700kb 10ms DropTail

$ns queue-limit $node1 $node2 5
$ns queue-limit $node2 $node3 5

#Building link node1 and node3
set udp_con_0 [new Agent/UDP]
$udp_con_0 set class_ 1
$ns attach-agent $node1 $udp_con_0

set sink_node_0 [new Agent/Null]
$ns attach-agent $node3 $sink_node_0

$ns connect $udp_con_0 $sink_node_0

$ns color 1 Red
$udp_con_0 set fid_ 1

set cbr_con_0 [new Application/Traffic/CBR]
$cbr_con_0 set packetSize_ 1500
$cbr_con_0 set interval_ 0.015
$cbr_con_0 attach-agent $udp_con_0

$ns at 0.2 "$cbr_con_0 start"
$ns at 1.8 "$cbr_con_0 stop"

$ns at 2.0 "end"

$ns run
