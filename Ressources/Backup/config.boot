interfaces {
    ethernet eth0 {
        address "172.16.3.254/24"
        hw-id "bc:24:11:b1:b6:7b"
    }
    ethernet eth1 {
        address "192.168.9.254/24"
        hw-id "bc:24:11:5a:07:dc"
    }
    ethernet eth2 {
        address "172.16.2.254/24"
        hw-id "bc:24:11:af:6a:ce"
    }
    loopback lo {
    }
}
protocols {
    static {
        route 0.0.0.0/0 {
            next-hop 172.16.2.253 {
            }
            next-hop 172.16.2.254 {
            }
            next-hop 172.16.3.254 {
            }
            next-hop 192.168.9.254 {
            }
        }
        route 10.0.0.0/24 {
        }
        route 10.7.0.0/16 {
        }
        route 10.10.0.0/24 {
            next-hop 172.16.2.254 {
            }
        }
        route 172.16.1.0/24 {
            next-hop 172.16.2.253 {
            }
        }
        route 172.16.2.0/24 {
            next-hop 172.16.2.254 {
            }
            next-hop 172.16.3.254 {
            }
            next-hop 192.168.9.254 {
            }
        }
        route 172.16.3.0/24 {
            next-hop 172.16.2.254 {
            }
            next-hop 192.168.9.254 {
            }
        }
        route 192.168.9.0/24 {
            next-hop 172.16.2.254 {
            }
            next-hop 172.16.3.254 {
            }
        }
    }
}
service {
    ntp {
        allow-client {
            address "127.0.0.0/8"
            address "169.254.0.0/16"
            address "10.0.0.0/8"
            address "172.16.0.0/12"
            address "192.168.0.0/16"
            address "::1/128"
            address "fe80::/10"
            address "fc00::/7"
        }
        server time1.vyos.net {
        }
        server time2.vyos.net {
        }
        server time3.vyos.net {
        }
    }
}
system {
    config-management {
        commit-revisions "100"
    }
    conntrack {
        modules {
            ftp
            h323
            nfs
            pptp
            sip
            sqlnet
            tftp
        }
    }
    console {
        device ttyS0 {
            speed "115200"
        }
    }
    host-name "vyos"
    login {
        user vyos {
            authentication {
                encrypted-password "$6$rounds=656000$wUvyoVJ5BjXZyKzG$SbLlbNQtyIZFNVLzMgA7FTBvQ7AHnhvOE.A3G72rExTlBb6WErhn2ldpKRQVTaI0ku6JQm20jqOiRr4BZzDp60"
                plaintext-password ""
            }
        }
    }
    option {
        keyboard-layout "fr"
    }
    syslog {
        global {
            facility all {
                level "info"
            }
            facility local7 {
                level "debug"
            }
        }
    }
}


// Warning: Do not remove the following line.
// vyos-config-version: "bgp@5:broadcast-relay@1:cluster@2:config-management@1:conntrack@5:conntrack-sync@2:container@2:dhcp-relay@2:dhcp-server@11:dhcpv6-server@5:dns-dynamic@4:dns-forwarding@4:firewall@15:flow-accounting@1:https@6:ids@1:interfaces@32:ipoe-server@3:ipsec@13:isis@3:l2tp@9:lldp@2:mdns@1:monitoring@1:nat@7:nat66@3:ntp@3:openconnect@3:openvpn@1:ospf@2:pim@1:policy@8:pppoe-server@10:pptp@5:qos@2:quagga@11:rip@1:rpki@2:salt@1:snmp@3:ssh@2:sstp@6:system@27:vrf@3:vrrp@4:vyos-accel-ppp@2:wanloadbalance@3:webproxy@2"
// Release version: 1.5-rolling-202405140019
