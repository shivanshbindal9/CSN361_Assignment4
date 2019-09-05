set ns [new Simulator]

#Routing Protocol used is Distance Vector
$ns rtproto DV

set nf [open q2.nam w]
set f [open q2.tr w]

$ns namtrace-all $nf
$ns trace-all $f

proc end {} {
    global ns nf f
    $ns flush-trace
    close $nf
    close $f
    exec nam q2.nam
    exit 0
}

# Create the network nodes
set node0 [$ns node]
set node1 [$ns node]
set node2 [$ns node]
set node3 [$ns node]
set node4 [$ns node]
set node5 [$ns node]

$node0 color blue
$node1 color green
$node2 color yellow
$node3 color orange
$node4 color pink


#Create links between the nodes
$ns duplex-link $node0 $node2 10Mb 10ms DropTail
$ns duplex-link $node1 $node2 1000kb 10ms DropTail
$ns duplex-link $node2 $node3 1Mb 10ms DropTail
$ns duplex-link $node3 $node4 1000Mb 10ms DropTail
$ns duplex-link $node3 $node5 500Mb 10ms DropTail


$ns queue-limit $node0 $node2 5
$ns queue-limit $node2 $node1 5
$ns queue-limit $node2 $node3 5
$ns queue-limit $node3 $node2 5
$ns queue-limit $node3 $node4 5
$ns queue-limit $node5 $node3 5

set p1 [new Agent/Ping]
$ns attach-agent $node0 $p1
$p1 set packetSize_ 50000
$p1 set interval_ 0.0001

$ns color 1 Red
$p1 set fid_ 1

set p2 [new Agent/Ping] 
$ns attach-agent $node4 $p2

$p2 set fid_ 1

set p3 [new Agent/Ping] 
$ns attach-agent $node5 $p3
$p3 set packetSize_ 30000
$p3 set interval_ 0.00001

$ns color 2 Green
$p3 set fid_ 2

set p4 [new Agent/Ping] 
$ns attach-agent $node1 $p4
$p4 set fid_ 2

Agent/Ping instproc recv {from rtt} {
$self instvar node_
puts "node [$node_ id] received answer from $from with round trip time $rtt msec"
}

$ns connect $p1 $p2
$ns connect $p3 $p4

for {set i 1} {$i < 30} {incr i} {
	$ns at [expr ($i) * 0.1] "$p1 send"
}

for {set i 1} {$i < 30} {incr i} {
	$ns at [expr ($i) * 0.1] "$p3 send"
}

$ns at 3.0 "end"
$ns run
