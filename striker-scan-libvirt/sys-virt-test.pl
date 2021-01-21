#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use Sys::Virt;


my $address = @ARGV ? shift @ARGV : "";
#my $address = @ARGV ? shift @ARGV : "qemu+ssh://localhost/system";
 
print "Address: [".$address."]\n";
 
my $libvirt_connection = Sys::Virt->new(address => $address, readonly => 1);
my @libvirt_domains    = $libvirt_connection->list_domains();
my $server_count       = @libvirt_domains;
print "- Found: [".$server_count."] servers.\n\n";
 
foreach my $domain (@libvirt_domains)
{
    my $domain_execution_state = $domain->get_info();
    my $domain_memory_stats    = $domain->memory_stats();
    my @domain_vcpu_info       = $domain->get_vcpu_info();
    my $core_count             = @domain_vcpu_info;
    
    print "\n";
    print "Server name: ............ [".$domain->get_name."] ID: [".$domain->get_id."]\n";
    print "- domain_execution_state: [".$domain_execution_state."]\n";
    print "- domain_memory_stats: .. [".$domain_memory_stats."]\n";
    print "- CPU Core count: ....... [".$core_count."]\n";
    foreach my $list_of_memory_stats (keys %{$domain_memory_stats})
    {
	print Dumper $list_of_memory_stats;die;
    }
    
    foreach my $list_of_vcpus (@domain_vcpu_info)
    {
        #my $key_count = keys %{$list_of_vcpus};
        #print " - VCPU key count: [".$key_count."]\n";
        
        #print Dumper $list_of_vcpus; die;
        
        my $affinity = $list_of_vcpus->{affinity};
        my $cpu      = $list_of_vcpus->{cpu};
        my $cpu_time = $list_of_vcpus->{cpuTime};
        my $number   = $list_of_vcpus->{number};
        my $state    = $list_of_vcpus->{'state'};
        print " - CPU: [".$number."], state: [".$state."], cpu: [".$cpu."], cpu_time: [".$cpu_time."]\n";
    }
}

