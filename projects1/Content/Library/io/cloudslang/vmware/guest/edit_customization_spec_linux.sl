####################################################
#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description:                 - Creates a customization spec as XML for a linux guest. It will not save it on vCenter.
#! @input host:                  - VMWare host hostname or IP.
#! @input user:                  - VMWare username.
#!                                 optional
#! @input password:              - VMWare user's password.
#! @input port:                  - Port to connect on.
#!                                 Default: 443
#! @input protocol:              - Connection protocol
#!                                 Valid values: "https", "http"
#!                                 Default: https
#! @input close_session:         - Close the internally kept VMware Infrastructure API session at completion of operation
#!                                 Valid values: "true", "false"
#! @input computer_name:         - An optional argument that is passed to the utility for this IP address (the meaning
#!                                  of this field is user-defined in the script) if the host_name_type is set to
#!                                  CustomName or the virtual machine name specified by the client if host_name_type is
#!                                  FixedName or base prefix, to which a unique number is appended if host_name_type is
#!                                  PrefixName.
#! @input host_name_type:        - The type of computer name.
#!                                 Valid values: CustomName, FixedName, PrefixName, UnknownName, VirtualMachineName
#! @input dns_server_list:       - List of DNS servers separated by ",", for a virtual network adapter with a static IP
#!                                  address. If this list is empty, then the guest operating system is expected to use a
#!                                  a DHCP server to get its DNS server settings. These settings configure the virtual
#!                                  machine to use the specified DNS servers. These DNS server settings are listed in
#!                                  order of preference.
#! @input dns_sufix_list:        - List of name resolution suffixes separated by "," for the virtual network adapter.
#! @input hw_clock_utc:          - Specifies whether the hardware clock is in UTC or local time.True when the hardware
#!                                  clock is in UTC.
#!                                 Valid values: "true", "false"
#!                                 Default value:"true"
#! @input timezone:              - The time zone for the new virtual machine.The case-sensitive timezone, such as
#!                                  "Area/Location"
#!                                 Example: "Europe/Bucharest".
#! @input domain:                - The fully qualified domain name.
#! @input nic_config:            - A JSONArray for configuring the NIC.
#!                                  Example: [{"macAddress":"","dnsDomain":"","gatewayList":"","subnetMask":"","ip":"",
#!                                            "ipV6Spec":""}]
#!                                  macAddress: The MAC address of a network adapter being customized. This property is
#!                                              optional.
#!                                  dnsDomain: A DNS domain suffix such as vmware.com.
#!                                  gatewayList: For a virtual network adapter with a static IP address, this data object
#!                                              type contains a list of gateways, in order of preference.
#!                                  subnetMask: Subnet mask for this virtual network adapter.
#!                                  ip: JSONObject containing IP config. Must have "ipType" (valid values:
#!                                              CustomIpGenerator(has an optional field "argument)", DhcpIpGenerator,
#!                                              FixedIp(has a required field "ipAddress"), UnknownIpGenerator).
#!                                              Example: {"ipType":"FixedIp","ipAddress":"324.23.42.124"}
#!                                  ipV6Spec: JSONObject containing the IpGenerator, subnet mask and gateway info for all
#!                                              the ipv6 addresses associated with the virtual network adapter.
#!                                              Example: {"gateway":"","ip",""}
#!                                              ip: JsonArray containing ipv6 address generators.
#!                                              Example: [{"ipType":"AutoIpV6Generator"},{"ipType":"CustomIpV6Generator",
#!                                              "argument":"optional"},{"ipType":"DhcpIpV6Generator"},{"ipType":
#!                                              "FixedIpV6","ipAddress":"","subnetMask":Integer},
#!                                              {"ipType":"StatelessIpV6Generator"},{"ipType":"UnknownIpV6Generator"}]
#! @input auth_type:             - The type of authentication used by this operation when trying to execute the request
#!                                  on the proxy server. The authentication is not preemptive: a plain request not
#!                                  including authentication info will be made and only when the server responds with a
#!                                  'WWW-Authenticate' header the client will send required headers. If the server needs
#!                                  no authentication but you specify one in this input the request will work
#!                                  nevertheless. The client cannot choose the authentication method and there is no
#!                                  fallback so you have to know which one you need
#!                                 Default value: basic
#!                                 Valid values: basic, digest or a list of valid values separated by comma
#!                                 Example: basic,digest
#! @input proxy_host:            - The proxy server used to access the web site.
#! @input proxy_port:            - The proxy server port.
#!                                 Default: 8443.
#!                                 Valid values: -1 and numbers greater than 0.
#! @input proxy_username:        - The user name used when connecting to the proxy. The "authType" input will be used to
#!                                  choose authentication type. The "basic" and "'digest" proxy authentication types are
#!                                  supported.
#! @input proxy_password:        - The proxy server password associated with the proxyUsername input value.
#! @input trust_all_roots:       - Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even
#!                                  if no trusted certification authority issued it
#!                                 Default value: false
#!                                 Valid values: true, false
#! @input x_509_hostname_verifier: - Specifies the way the server hostname must match a domain name in the subject's
#!                                  Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to
#!                                  "allow_all" to skip any checking, but you become vulnerable to attacks. For the
#!                                  value "browser_compatible" the hostname verifier works the same way as Curl and
#!                                  Firefox. The hostname must match either the first CN, or any of the subject-alts. A
#!                                  wildcard can occur in the CN, and in any of the subject-alts. The only difference
#!                                  between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com")
#!                                  with "browser_compatible" matches all subdomains, including "a.b.foo.com". From the
#!                                  security perspective, to provide protection against possible Man-In-The-Middle
#!                                  attacks, we strongly recommend to use "strict" option
#!                                 Default value: strict
#!                                 Valid values: strict,browser_compatible,allow_all
#! @input trust_keystore:        - The pathname of the Java TrustStore file. This contains certificates from other
#!                                  parties that you expect to communicate with, or from Certificate Authorities that
#!                                  you trust to identify other parties. If the protocol (specified by the 'url') is not
#!                                  "https" or if trustAllRoots is "true" this input is ignored.
#!                                 Default value: <OO_Home>/java/lib/security/cacerts
#!                                 Format: Java KeyStore (JKS)
#! @input trust_password:        - The password associated with the TrustStore file. If trustAllRoots is false and
#!                                  trust_keystore is empty, trustPassword default will be supplied
#! @input keystore:              - The pathname of the Java KeyStore file. You only need this if the server requires
#!                                  client authentication. If the protocol (specified by the URL) is not "https" or if
#!                                  trustAllRoots is "true" this input is ignored.
#!                                 Default value: <OO_Home>/java/lib/security/cacerts
#!                                 Format: Java KeyStore (JKS)
#! @input keystore_password:     - The password associated with the KeyStore file. If trust_all_roots is false and
#!                                  keystore is empty, keystore_password default will be supplied
#! @output return_result:        - This is the primary output. Task result or operation result. Reason for error on failure.
#! @output return_code:          - The return code of the operation.
#! @result SUCCESS:              - The operation completed as stated in the description. (return_code 0)
#! @result FAILURE:              - Something went wrong. See return_result for details.(return_code -1)
#! Notes:
#! 1. Timezoneare valid values are based on the tz (timezone) database used by Linux and other Unix systems. The values
#!                                are strings (xsd:string) in the form "Area/Location," in which Area is a continent or
#!                                ocean name, and Location is the city, island, or other regional designation.
#!                               - Valid Values can be found here: http://pubs.vmware.com/vsphere-55/index.jsp?topic=%2Fcom.vmware.wssdk.apiref.doc%2Ftimezone.html.
#!!#
####################################################
namespace: io.cloudslang.vmware.guest
operation: 
   name: edit_customization_spec_linux
   inputs: 
   -  host
   -  user: 
         required: false
   -  password: 
         sensitive: true
   -  port:
         default: "443"
   -  protocol:
         default: "https"
   -  close_session:
         default: "true"
   -  closeSession:
         private: true
         default: ${get("close_session", "")}
         sensitive: false
         required: false
   -  computer_name:
         required: false
   -  computerName:
         private: true
         default: ${get("computer_name", "")}
         sensitive: false
         required: false
   -  host_name_type:
         required: false
   -  hostNameType:
         private: true
         default: ${get("host_name_type", "")}
         sensitive: false
         required: false
   -  dns_server_list:
         required: false
   -  dnsServerList:
         private: true
         default: ${get("dns_server_list", "")}
         sensitive: false
         required: false
   -  dns_sufix_list:
         required: false
   -  dnsSufixList:
         private: true
         default: ${get("dns_sufix_list", "")}
         sensitive: false
         required: false
   -  nic_config:
         required: false
   -  nicConfig:
         private: true
         default: ${get("nic_config", "")}
         sensitive: false
         required: false
   -  hw_clock_utc:
         required: false
   -  hwClockUTC:
         private: true
         default: ${get("hw_clock_utc", "")}
         sensitive: false
         required: false
   -  time_zone: 
         required: false
   -  timeZone: 
         private: true
         default: ${get("time_zone", "")}
         sensitive: false
         required: false
   -  domain: 
         required: false
   -  auth_type:
         default: "basic"
         private: false
         sensitive: false
         required: false
   -  authType: 
         private: true
         default: ${get("auth_type", "")}
         sensitive: false
         required: false
   -  proxy_host: 
         private: false
         sensitive: false
         required: false
   -  proxyHost: 
         private: true
         default: ${get("proxy_host", "")}
         sensitive: false
         required: false
   -  proxy_port:
         default: "8443"
         private: false
         sensitive: false
         required: false
   -  proxyPort: 
         private: true
         default: ${get("proxy_port", "")}
         sensitive: false
         required: false
   -  proxy_username: 
         private: false
         sensitive: false
         required: false
   -  proxyUsername: 
         private: true
         default: ${get("proxy_username", "")}
         sensitive: false
         required: false
   -  proxy_password: 
         private: false
         sensitive: true
         required: false
   -  proxyPassword: 
         private: true
         default: ${get("proxy_password", "")}
         sensitive: true
         required: false
   -  trust_all_roots:
         default: "false"
         private: false
         sensitive: false
         required: false
   -  trustAllRoots: 
         private: true
         default: ${get("trust_all_roots", "")}
         sensitive: false
         required: false
   -  x_509_hostname_verifier:
         default: "strict"
         private: false
         sensitive: false
         required: false
   -  x509HostnameVerifier: 
         private: true
         default: ${get("x_509_hostname_verifier", "")}
         sensitive: false
         required: false
   -  trust_keystore: 
         private: false
         sensitive: false
         required: false
   -  trustKeystore: 
         private: true
         default: ${get("trust_keystore", "")}
         sensitive: false
         required: false
   -  trust_password:
         private: false
         sensitive: true
         required: false
   -  trustPassword: 
         private: true
         default: ${get("trust_password", "")}
         sensitive: true
         required: false
   -  keystore: 
         private: false
         sensitive: false
         required: false
   -  keystore_password:
         private: false
         sensitive: true
         required: false
   -  keystorePassword: 
         private: true
         default: ${get("keystore_password", "")}
         sensitive: true
         required: false
   java_action:
      gav: 'io.cloudslang.content:cs-vmware-vcenter-sources:1.0.0-SNAPSHOT'
      method_name: execute
      class_name: io.cloudslang.content.actions.vmware.guest.EditCustomizationSpecLinux
   outputs:
   -  return_code: ${returnCode}
   -  failure_message: ${get("failureMessage")}
   -  return_result: ${returnResult}
   results: 
   -  SUCCESS: ${returnCode=='0'}
   -  FAILURE: ${returnCode=='-1'}
