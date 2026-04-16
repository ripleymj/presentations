
:global defconfMode;
:log info "Starting defconf script";
# wait for interfaces
:local count 0;
:while ([/interface ethernet find] = "") do={
  :if ($count = 30) do={
    :log warning "DefConf: Unable to find ethernet interfaces";
    /quit;
  }
  :delay 1s; :set count ($count +1); 
};

:if ([/system routerboard get serial-number] = "661705E84C20") do={
  :global hostname Router-A1;
  :global loopip 192.168.0.1;
}
:if ([/system routerboard get serial-number] = "6617057F96EF") do={
  :global hostname Router-A2;
  :global loopip 192.168.0.2;
}
:if ([/system routerboard get serial-number] = "66170556F52C") do={
  :global hostname Router-A3;
  :global loopip 192.168.0.3;
}
:if ([/system routerboard get serial-number] = "5C15040AB665") do={
  :global hostname Router-A4;
  :global loopip 192.168.0.4;
}

:if ([/system routerboard get serial-number] = "9D75090A2D04") do={
  :global hostname Router-B1;
  :global loopip 192.168.0.5;
}
:if ([/system routerboard get serial-number] = "9D7509B24C5C") do={
  :global hostname Router-B2;
  :global loopip 192.168.0.6;
}
:if ([/system routerboard get serial-number] = "9D7509D149BD") do={
  :global hostname Router-B3;
  :global loopip 192.168.0.7;
}
:if ([/system routerboard get serial-number] = "9D7509379AFC") do={
  :global hostname Router-B4;
  :global loopip 192.168.0.8;
}

:if ([/system routerboard get serial-number] = "4674048C73A0") do={
  :global hostname Router-C;
  :global loopip 192.168.0.9;
}

/system/identity/set name=$hostname
/ip/address/add address=$loopip netmask=255.255.255.255 interface=lo
/interface wireless set wlan1 disabled=no country="united states" ssid=$hostname mode=ap-bridge
#/interface pwr-line set pwr-line1 disabled=yes

/ip/vrf/add name=mgmt interfaces=wlan1 place-before=0
/ip/service/set www vrf=mgmt
/ip/service/set www-ssl vrf=mgmt
/ip/service/set ssh vrf=mgmt

/ip pool add name="default-dhcp" ranges=192.168.88.10-192.168.88.254;
/ip dhcp-server add name=defconf address-pool="default-dhcp" interface=wlan1 disabled=no;
/ip dhcp-server network add address=192.168.88.0/24 gateway=192.168.88.1 dns-server=192.168.88.1;
/ip address add address=192.168.88.1/24 interface=wlan1;

/ip firewall {
  filter add chain=input action=accept
  filter add chain=forward action=accept
}

/ip neighbor discovery-settings set discover-interface-list=all
/tool mac-server set allowed-interface-list=all
/tool mac-server mac-winbox set allowed-interface-list=all
/user set admin password=admin