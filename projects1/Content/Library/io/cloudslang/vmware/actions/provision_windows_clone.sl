####################################################
#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description:                 - Clones and configures a virtual machine. The virtual machine may be a template vm.
#!                                  The source virtual machine is specified via vmIdentifierType, vm_src_name
#!                                  and vm_datacenter while the clone is defined by vm_dest_name,vmFolder,
#!                                  vmResourcePool,dataStore,hostSystem, and clusterName.
#!                                  Note: cannot work across virtual datacenters
#! @input host:                  - VMWare host hostname or IP.
#! @input user:                  - VMWare username.
#!                                 Optional
#! @input password:              - VMWare user's password.
#! @input port:                  - Port to connect on.
#!                                 Default: 443
#! @input protocol:              - Connection protocol
#!                                 Valid values: "https", "http"
#!                                 Default: https
#! @input close_session:         - Close the internally kept VMware Infrastructure API session at completion of operation
#!                                 Valid values: "true", "false"
#! @input async:                 - Asynchronously perform the task
#!                                 Valid values: "true", "false"
#!                                 Default: "false"
#! @input task_time_out:         - Time to wait before the operation is considered to have failed (seconds).
#!                                 Default: 800
#! @input vm_identifier_type:    - Virtual machine identifier type.
#!                                 Valid values: "inventorypath", "name", "ip", "hostname", "uuid", "vmid"
#! @input vm_src_name:           - Primary Virtual Machine identifier of the virtual machine to clone from.
#!                                  Inventorypath (Datacenter/vm/Folder/MyVM), Name of VM, IP (IPv4 or IPv6
#!                                  depending upon ESX version), hostname (full), UUID, or the VM id (vm-123,123).
#! @input vm_datacenter:         - Virtual machine's datacenter. If host is ESX(i) use "ha-datacenter".
#! @input vm_dest_name:          - Name of new virtual machine being created.
#! @input vm_folder:             - Virtual machine's inventory folder. Folder names are delimited by a forward
#!                                  slash "/".  This input is case sensitive.  Only supported when host is a
#!                                  vCenter.  For root folder, use "/".
#!                                 Example: /Hewlett Packard Enterprise/Operations Orchestration/Templates and VMs/
#! @input vm_resource_pool:      - Resource pool for new virtual machine. Resource pool names are delimited by a
#!                                  forward slash "/".  For the root resource pool, specify "Resources" or a single "/".
#! @input data_store:            - Name of datastore or datastore cluster to store new virtual machine.
#!                                  If not specified the same datastore of the source virtual machine will be used.
#!                                 Example: host:dsname, mydatastore.
#! @input host_system:           - Name of destination host system (ESX or ESXi) for new virtual machine as seen in
#!                                  the vCenter UI.  Only supported when host is a vCenter.  If not specified the
#!                                  same host system of the source virtual machine will be used.
#! @input cluster_name:          - Name of the VMWare HA or DRS cluster.  Can be specified instead of hostSystem
#!                                  if the desired destination ESX(i) host is in a DRS or HA cluster.
#! @input description:           - Description / annotation. To be able to clone the machine, even when no
#!                                  description input is given, the user needs to have the following permission
#!                                  to the virtual machine: Virtual machine -> Configuration -> Set annotation.
#! @input mark_as_template:      - Mark the virtual machine as a template? If true virtual machine will be marked
#!                                  as a template.  Mark as regular virtual machine otherwise.
#!                                 Valid values: "true", "false".
#! @input thin_provision:        - Specify whether to perform thin provisioning of the virtual disk. If empty,
#!                                  the disk format will be set as same format as source. If true, the disk format
#!                                  will be set as thin provisioned format. If false, the disk format will be set
#!                                  as thick format.
#!                                 Valid values: "true", "false"
#! @input customization_template_name: - Name of the customization specification to apply while creating this clone.
#!                                  The customization specification should already exist in the vCenter
#!                                  customization specifications manager. If  both 'customizationTemplateName'
#!                                  and 'customizationSpecXml' have values, the operation will fail with an error
#!                                  message.
#! @input customization_spec_xml:- The Xml string of the customization spec.
#! @input connection_timeout:    - The time to wait for a connection to be established, in seconds. A
#!                                  "connection_timeout" value of '0' represents an infinite timeout.
#!                                 Default value: 0
#!                                 Format: an integer representing seconds
#!                                 Examples: 10, 20
#! @input cpu_provision_type:    - Type of provision. If set to no_provision the vm cpu won't be changed and the value
#!                                  from new_cpu_count will be ignored, if set to provision the vm cpu will be set to
#!                                  new_cpu_count, if set to flexup the cpu will be the current cpu count+new_cpu_count,
#!                                  if set to flexdown the cpu will be set to current cpu count - new_cpu_count
#!                                 Valid values: no_provision, provision, flexup, flexdown
#!                                 Default value: provision
#! @input new_cpu_count:         - The new count of CPU or the amount of cpu to add/remove.
#! @input memory_provision_type: - Type of provision. If set to no_provision the memory won't be changed and the value
#!                                  from new_memory_size will be ignored, if set to provision the memory will be set to
#!                                  new_memory_size, if set to flexup the memory will be the current memory size +
#!                                  new_memory_size, if set to flexdown the memory will be set to current memory size -
#!                                  new_cpu_count.
#!                                 Valid values: no_provision, provision, flexup, flexdown
#!                                 Default value: provision
#! @input new_memory_size:       - The new size of memory or the amount of cpu to add/remove.
#! @input computer_name:         - The computer name of the (Windows) virtual machine. Computer name may contain letters
#!                                  (A-Z), numbers(0-9) and hyphens (-) but no spaces or periods (.). The name may not
#!                                  consists entirely of digits.
#! @input nic_config:            - A JSONArray for configuring the NIC.
#!                                  Example: [{"macAddress":"","dnsDomain":"","gatewayList":"","subnetMask":"","ip":"",
#!                                            "ipV6Spec":"","dnsServerList":""}]
#!                                  macAddress: The MAC address of a network adapter being customized. This property is
#!                                              optional.
#!                                  dnsDomain: A DNS domain suffix such as vmware.com.
#!                                  gatewayList: For a virtual network adapter with a static IP address, this data object
#!                                              type contains a list of gateways, in order of preference.
#!                                  subnetMask: Subnet mask for this virtual network adapter.
#!                                  dnsServerList: A list of server IP addresses to use for DNS lookup.
#!                                  netBios: NetBIOS setting for Windows.
#!                                           Valid Values: disableNetBIOS, enableNetBIOS, enableNetBIOSViaDhcp
#!                                  primaryWINS: The IP address of the primary WINS server. This property is ignored
#!                                                for Linux guest operating systems.
#!                                  secondaryWINS: The IP address of the secondary WINS server. This property is ignored
#!                                                for Linux guest operating systems.
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
#! @input timezone:              - The time zone for the new virtual machine.
#!                                 Example: 4.
#! @input product_key:           - A valid serial number be included in the answer file.
#! @input administrator_password:- The administrator password for Virtual Machine.
#! @input owner_name:            - The user's full name.
#! @input owner_organization:    - The user's organization.
#! @input domain:                - The domain that the virtual machine should join. If this value is supplied, then
#!                                  domain_username and domain_password must also be supplied, and the workgroup name
#!                                  must be empty.
#! @input domain_username:       - This is the domain user account used for authentication if the virtual machine is
#!                                  joining a domain. The user must have the privileges required to add computers to the domain.
#! @input domain_password:       - This is the password for the domain user account used for authentication if the virtual
#!                                  machine is joining a domain.
#! @input workgroup:             - The workgroup that the virtual machine should join. If this value is supplied, then
#!                                  the domain name and authentication fields must be empty.
#! @input socket_timeout:        - The time to wait for data (a maximum period of inactivity between two consecutive
#!                                  data packets), in seconds. A "socketTimeout" value of '0' represents an infinite
#!                                  timeout.
#!                                 Default value: 0
#!                                 Format: an integer representing seconds
#!                                 Examples: 10, 20
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
#! @output return_result:        - Task result or operation result.
#! @output vm_id:                - The ID of the new vm in case of SUCCESS.
#! @output inventory_path:       - The inventory path of the new vm in case of SUCCESS. The path is build regarding the
#!                                  "host" input value. Read Inventory Path Formatting for more details.
#! @output return_code:          - The return code of the operation. (0,-1)
#! @result SUCCESS:              - The operation completed successfully. (return_code 0)
#! @result FAILURE:              - Something went wrong. (return_code -1)
#! Notes:
#! 1) Inventory Path Formatting: If host is an ESX server inventory path will be: ha-datacenter/vm/<name of vm> .
#!                                If host is a vCenter the inventory path will be: <name of datacenter>/vm/<folders>/<name of vm> .
#!                                The <folders>/<name of vm> part of the path is based on the "Virtual Machines & Templates"
#!                                view in the vCenter client. The inventory path is case sensitive.
#! 2) This operation can also be used to deploy a virtual machine from template, clone virtual machine to template
#!                                and clone a template to template.
#! 3) The result of the VMware/VMware Virtual Infrastructure and vSphere/Guest/Export Guest Customization Spec
#!                                operation can be used to get the customizationSpecXml input value.
#! 4) The privilege required on the source virtual machine depends on the source and destination types:
#!                                - source is virtual machine, destination is virtual machine - VirtualMachine.Provisioning.Clone
#!                                - source is virtual machine, destination is template - VirtualMachine.Provisioning.CreateTemplateFromVM
#!                                - source is template, destination is virtual machine - VirtualMachine.Provisioning.DeployTemplate
#!                                - source is template, destination is template - VirtualMachine.Provisioning.CloneTemplate
#! 5) Note that "socketTimeout" and "connectionTimeout" inputs do not represent the time to wait for the operation
#!                                to complete. They are used when communicating with the service, to make sure that
#!                                the service is up and responds to client's requests. They can be used for service
#!                                diagnosis purpose.
#! 6) The "taskTimeOut" input is only used when the task is performed in a synchronous manner ("async" is set to
#!                                "false").
#!!#
####################################################
namespace: io.cloudslang.vmware.actions
imports:
   actions: io.cloudslang.vmware.actions
   guest: io.cloudslang.vmware.guest
flow:
   name: provision_windows_clone
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
   -  async:
         default: "false"
         required: true
   -  timeout:
         default: "800"
         required: false
   -  vm_identifier_type
   -  vm_src_name
   -  vm_datacenter
   -  vm_dest_name
   -  vm_folder
   -  vm_resource_pool:
         required: false
   -  data_store:
         required: false
   -  host_system:
         required: false
   -  cluster_name:
         required: false
   -  description:
         required: false
   -  mark_as_template:
         default: "false"
   -  thin_provision:
         required: false
   -  connection_timeout:
         default: "0"
         required: false
   -  socket_timeout:
         default: "0"
         required: false
   -  cpu_provision_type
   -  new_cpu_count:
         required: false
   -  memory_provision_type
   -  new_memory_size:
         required: false
   -  computer_name:
         required: false
   -  nic_config:
         required: false
   -  time_zone:
         required: false
   -  product_key:
         required: false
         sensitive: true
   -  administrator_password:
         sensitive: true
         required: false
   -  owner_name:
         required: false
   -  owner_organization:
         required: false
   -  domain:
         required: false
   -  domain_username:
         required: false
   -  domain_password:
         sensitive: true
         required: false
   -  workgroup:
         required: false
   -  auth_type:
         default: "basic"
         private: false
         sensitive: false
         required: false
   -  proxy_host:
         required: false
   -  proxy_port:
         default: "8443"
         required: false
   -  proxy_username:
         required: false
   -  proxy_password:
         sensitive: true
         required: false
   -  trust_all_roots:
         default: "false"
         required: false
   -  x_509_hostname_verifier:
         default: "strict"
         required: false
   -  trust_keystore:
         required: false
   -  trust_password:
         sensitive: true
         required: false
   -  keystore:
         required: false
   -  keystore_password:
         sensitive: true
         required: false
   workflow:
   -  create_windows_customization_spec:
         do:
            guest.edit_customization_spec_windows:
            -  host
            -  user
            -  password
            -  port
            -  protocol
            -  computer_name
            -  nic_config
            -  time_zone
            -  product_key
            -  administrator_password
            -  owner_name
            -  owner_organization
            -  domain
            -  domain_username
            -  domain_password
            -  workgroup
            -  auth_type
            -  proxy_host
            -  proxy_port
            -  proxy_username
            -  proxy_password
            -  trust_all_roots
            -  x_509_hostname_verifier
            -  trust_keystore
            -  trust_password
            -  keystore
            -  keystore_password
         publish:
            -  customization_spec_xml: ${return_result if return_code=='0' else ''}
            -  return_result
            -  failure_message
            -  return_code
         navigate:
         -  SUCCESS: provision_clone
         -  FAILURE: FAILURE
   -  provision_clone:
         do:
            actions.provision_clone:
            -  host
            -  user
            -  password
            -  port
            -  protocol
            -  async
            -  timeout
            -  vm_identifier_type
            -  vm_src_name
            -  vm_datacenter
            -  vm_dest_name
            -  vm_folder
            -  vm_resource_pool
            -  data_store
            -  host_system
            -  cluster_name
            -  description
            -  mark_as_template
            -  thin_provision
            -  customization_spec_xml
            -  connection_timeout
            -  socket_timeout
            -  cpu_provision_type
            -  new_cpu_count
            -  memory_provision_type
            -  new_memory_size
            -  auth_type
            -  proxy_host
            -  proxy_port
            -  proxy_username
            -  proxy_password
            -  trust_all_roots
            -  x_509_hostname_verifier
            -  trust_keystore
            -  trust_password
            -  keystore
            -  keystore_password
         publish:
            -  vm_id
            -  ip_address
            -  fqdn
            -  inventory_path
            -  guest_full_name
            -  return_code
            -  return_result
            -  failure_message
         navigate:
         -  SUCCESS: SUCCESS
         -  FAILURE: FAILURE
   outputs:
   -  vm_id
   -  ip_address
   -  fqdn
   -  inventory_path
   -  guest_full_name
   -  return_code
   -  return_result
   -  failure_message
   results:
   - FAILURE
   - SUCCESS
