####################################################
#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description:                 - Retrieves the configured number of CPUs for a virtual machine.
#! @input host:                  - VMWare host hostname or IP.
#! @input user:                  - VMWare username.
#!                               - optional
#! @input password:              - VMWare user's password.
#! @input port:                  - Port to connect on.
#!                               - Default: 443
#! @input protocol:              - Connection protocol
#!                               - Valid values: "https", "http"
#!                               - Default: https
#! @input close_session:         - optional
#!                               - Close the internally kept VMware Infrastructure API session at completion of operation
#!                               - Valid values: "true", "false"
#! @input virtual_machine:       - Primary Virtual Machine identifier. Inventorypath (Datacenter/vm/Folder/MyVM), Name of VM,
#!                                  IP (IPv4 or IPv6 depending upon ESX version), hostname (full), UUID, or the VM id (vm-123,123).
#! @input vm_identifier_type:    - Virtual machine identifier type
#!                                 Valid values: "inventorypath", "name", "ip", "hostname", "uuid", "vmid"
#! @input vm_datacenter:         - Datacenter to get virtual machine from.
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
#! @output failure_message:      - Populated in case of failure; contains the reason for failure
#! @output vm_cpu_count:         - Number of CPU sockets configured for the virtual machine.
#! @output vm_cores_per_socket:  - Number of CPU cores per socket configured for the virtual machine.
#! @output return_code:          - The return code of the flow.
#! @result SUCCESS:              - The flow completed successfully (return_code 0)
#! @result FAILURE:              - Something went wrong. See return_result for details.(return_code -1)
#! Notes:
#! 1. Inventory Path Formatting: if host is an ESX server then inventory path will be: ha-datacenter/vm/"name of vm",
#!                                if host is an vCenter then the inventory path will be: "name of datacenter"/vm/"folders"/"name
#!                                of vm". The "folders"/"name of vm" part of the path is based on the "Virtual Machines & Templates"
#!                                view in the vCenter client. The inventory path is case sensitive.
#!!#
####################################################
namespace: io.cloudslang.vmware.vm.conf
imports:
   vm: io.cloudslang.vmware.vm
   util: io.cloudslang.vmware.util
   json: io.cloudslang.base.json
   math: io.cloudslang.base.math
flow:
   name: get_vm_cpu_count
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
   -  vm_identifier_type
   -  virtual_machine
   -  vm_datacenter:
         required: false
   -  auth_type:
         default: "basic"
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
   -  get_virtual_machine:
         do:
            vm.get_vm:
            -  host
            -  user
            -  password
            -  port
            -  protocol
            -  vm_identifier_type
            -  virtual_machine
            -  vm_datacenter
            -  details: "config.hardware.numCPU"
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
            -  failure_message: ${return_result if return_code!='0' else ''}
            -  return_code: ${'-1' if return_code!='0' else return_code}
            -  props_root_obj: ${vm_id}
            -  vm_info
         navigate:
         -  SUCCESS: filter_vm_cpu_count
         -  FAILURE: FAILURE
   -  filter_vm_cpu_count:
         do:
            json.get_value:
            -  json_path: ["config.hardware.numCPU"]
            -  json_input: ${vm_info}
         publish:
            -  vm_cpu_count: ${value}
            -  return_code
            -  failure_message: ${error_message}
         navigate:
         -  SUCCESS: get_api_version
         -  FAILURE: FAILURE
   -  get_api_version:
         do:
            util.advanced_search:
            -  host
            -  user
            -  password
            -  port
            -  protocol
            -  props_type: "ServiceInstance"
            -  props_pathset: "content.about.apiVersion"
            -  props_root_obj_type: "ServiceInstance"
            -  props_root_obj: "ServiceInstance"
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
            -  failure_message: ${return_result if return_code!='0' else ''}
            -  json_version: ${return_result if return_code=='0' else ''}
            -  return_code: ${'-1' if return_code!='0' else return_code}
         navigate:
         -  SUCCESS: filter_version
         -  FAILURE: FAILURE
         -  NO_MORE: FAILURE
   -  filter_version:
         do:
            json.get_value:
            -  json_path: [0, "content.about.apiVersion"]
            -  json_input: ${json_version}
         publish:
            -  version: ${value}
            -  failure_message: ${error_message}
            -  return_code
         navigate:
         -  SUCCESS: is_api_version_greater_or_equal_than_5
         -  FAILURE: FAILURE
   -  is_api_version_greater_or_equal_than_5:
         do:
            math.compare_numbers:
            -  value1: ${version}
            -  value2: "5"
         publish:
            -  vm_cores_per_socket: ${'1' if float(value1) > float(value2) else ''}
         navigate:
         -  GREATER_THAN: get_vm_cores_per_socket
         -  EQUALS: get_vm_cores_per_socket
         -  LESS_THAN: SUCCESS
   -  get_vm_cores_per_socket:
         do:
            util.advanced_search:
            -  host
            -  user
            -  password
            -  port
            -  protocol
            -  props_type: "VirtualMachine"
            -  props_pathset: "config.hardware.numCoresPerSocket"
            -  props_root_obj_type: "VirtualMachine"
            -  props_root_obj: ${props_root_obj}
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
            -  failure_message: ${return_result if return_code!='0' else ''}
            -  vm_cores_per_socket_json: ${return_result if return_code=='0' else ''}
            -  return_code: ${'-1' if return_code!='0' else return_code}
         navigate:
         -  SUCCESS: filter_vm_cores_per_socket
         -  FAILURE: FAILURE
         -  NO_MORE: FAILURE
   -  filter_vm_cores_per_socket:
         do:
            json.get_value:
            -  json_path: [0, "config.hardware.numCoresPerSocket"]
            -  json_input: ${vm_cores_per_socket_json}
         publish:
            -  vm_cores_per_socket: ${value}
            -  failure_message: ${error_message}
            -  return_code
         navigate:
         -  SUCCESS: SUCCESS
         -  FAILURE: FAILURE
   outputs:
   - vm_cores_per_socket
   - vm_cpu_count
   - return_code
   - failure_message
   results:
   - FAILURE
   - SUCCESS