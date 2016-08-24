####################################################
#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description:                 - Powers off the VM, by shuting down the guest or by force power off.
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
#! @input virtual_machine:       - Primary Virtual Machine identifier. Inventorypath (Datacenter/vm/Folder/MyVM), Name of VM,
#!                                  IP (IPv4 or IPv6 depending upon ESX version), hostname (full), UUID, or the VM id (vm-123,123).
#! @input vm_identifier_type:    - Virtual machine identifier type - Valid values: "inventorypath", "name", "ip", "hostname",
#!                                  "uuid", "vmid"
#! @input wait_guest:            - If this is true the VM will first shutdown guest (requires VM tools), otherwise
#!                                  it will force power off. If this input is provided retries and check_guest_running_delay
#!                                  must be provided.
#!                                 Default: true
#! @input retries:               - Number of checks if the guest has been shutdown. After these retries the VM will be
#!                                  forces shut down.
#!                                 Default: 60
#! @input check_guest_running_delay:- The delays between checks if the guest has been shutdown. The value is in seconds.
#!                                  The total time before the guest is force shutdown is
#!                                  check_guest_running_delay * retries (default 300 seconds)
#!                                 Default: 5
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
#! @output return_result:        - Task ID or task completion return message.
#! @output return_code:          - The return code of the operation. (0,-1)
#! @result SUCCESS:              - The machine has been powered off (return_code 0)
#! @result FAILURE:              - An exception occured (return_code -1)
#! Notes:
#! 1. Inventory Path Formatting: if host is an ESX server then inventory path will be: ha-datacenter/vm/"name of vm",
#!                                if host is an vCenter then the inventory path will be: "name of datacenter"/vm/"folders"/"name
#!                                of vm". The "folders"/"name of vm" part of the path is based on the "Virtual Machines & Templates"
#!                                view in the vCenter client. The inventory path is case sensitive.
#!!#
####################################################
namespace: io.cloudslang.vmware.power
imports:
   strings: io.cloudslang.base.strings
   math: io.cloudslang.base.math
   utils: io.cloudslang.base.utils
   guest: io.cloudslang.vmware.guest
   power: io.cloudslang.vmware.power
flow:
   name: power_off
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
   -  async:
         default: "false"
   -  task_time_out:
         default: "800"
         required: false
   -  vm_datacenter:
         required: false
   -  wait_guest:
         default: "true"
         required: true
   -  retries:
         default: "60"
         required: false
   -  check_guest_running_delay:
         default: "5"
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
   -  get_vm_power_state:
         do:
            power.get_power_state:
            -  host
            -  user
            -  password
            -  port
            -  protocol
            -  vm_identifier_type
            -  virtual_machine
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
            -  return_code
            -  failure_message: ${return_result if return_code=='-1' else ''}
            -  current_power_state: ${return_result if return_code=='0' else ''}
         navigate:
         -  SUCCESS: check_is_already_powered_off
         -  FAILURE: FAILURE
   -  check_is_already_powered_off:
         do:
            strings.string_equals:
            -  first_string: ${current_power_state}
            -  second_string: "poweredOff"
            -  ignore_case: "true"
         navigate:
         -  SUCCESS: SUCCESS
         -  FAILURE: power_on_vm
   -  power_on_vm:
         do:
            power.power_on:
            -  host
            -  user
            -  password
            -  port
            -  protocol
            -  async
            -  task_time_out
            -  vm_identifier_type
            -  virtual_machine
            -  vm_datacenter
            -  wait_guest
            -  retries
            -  check_guest_running_delay
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
            -  return_code
            -  failure_message
         navigate:
         -  SUCCESS: is_required_to_wait_guest
         -  FAILURE: FAILURE
   -  is_required_to_wait_guest:
         do:
            strings.string_equals:
            -  first_string: ${wait_guest}
            -  second_string: "true"
            -  ignore_case: "true"
         navigate:
         -  SUCCESS: shutdown_guest
         -  FAILURE: force_power_off
   -  force_power_off:
         do:
            power.set_power_state:
            -  host
            -  user
            -  password
            -  port
            -  protocol
            -  async
            -  task_time_out
            -  vm_identifier_type
            -  virtual_machine
            -  vm_power_state: "poweredOff"
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
            -  return_code
            -  failure_message: ${return_result if return_code=='-1' else ''}
         navigate:
         -  SUCCESS: get_current_power_state
         -  NO_ACTION: get_current_power_state
         -  FAILURE: FAILURE
   -  get_current_power_state:
         do:
            power.get_power_state:
            -  host
            -  user
            -  password
            -  port
            -  protocol
            -  vm_identifier_type
            -  virtual_machine
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
            -  return_code
            -  failure_message: ${return_result if return_code=='-1' else ''}
            -  current_power_state: ${return_result if return_code=='0' else ''}
         navigate:
         -  SUCCESS: is_requested_power_state
         -  FAILURE: FAILURE
   -  is_requested_power_state:
         do:
            strings.string_equals:
            -  first_string: ${current_power_state}
            -  second_string: "poweredOff"
            -  ignore_case: "true"
         navigate:
         -  SUCCESS: SUCCESS
         -  FAILURE: unable_to_power_off_vm
   -  unable_to_power_off_vm:
         do:
            math.add_numbers:
            -  value1: "1"
            -  value2: "1"
         publish:
            -  failure_message: 'Unable to power off the vm'
            -  return_code: "-1"
         navigate:
         -  SUCCESS: FAILURE
         -  FAILURE: FAILURE
   -  shutdown_guest:
         do:
            guest.shutdown_guest:
            -  host
            -  user
            -  password
            -  port
            -  protocol
            -  vm_identifier_type
            -  virtual_machine
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
            -  failure_message: ${return_result if return_code=='-1' else ''}
            -  return_code
         navigate:
         -  SUCCESS: loop
         -  FAILURE: FAILURE
   -  loop:
         do:
            math.compare_numbers:
            -  value1: ${retries}
            -  value2: "0"
         navigate:
         -  GREATER_THAN: decrement_retries
         -  EQUALS: force_power_off
         -  LESS_THAN: force_power_off
   -  decrement_retries:
         do:
            math.subtract_numbers:
            -  value1: ${retries}
            -  value2: "1"
         publish:
            -  retries: ${result}
         navigate:
         -  SUCCESS: sleep
         -  FAILURE: FAILURE
   -  sleep:
         do:
            utils.sleep:
            -  seconds: ${check_guest_running_delay}
         publish:
            -  failure_message: ${error_message}
            -  return_code: ${'0' if error_message=='' else '-1'}
         navigate:
         -  SUCCESS: get_power_state
         -  FAILURE: FAILURE
   -  get_power_state:
         do:
            power.get_power_state:
            -  host
            -  user
            -  password
            -  port
            -  protocol
            -  vm_identifier_type
            -  virtual_machine
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
            -  return_code
            -  failure_message: ${return_result if return_code=='-1' else ''}
            -  current_power_state: ${return_result if return_code=='0' else ''}
         navigate:
         -  SUCCESS: check_is_powered_off
         -  FAILURE: FAILURE
   -  check_is_powered_off:
         do:
            strings.string_equals:
            -  first_string: ${current_power_state}
            -  second_string: "poweredOff"
            -  ignore_case: "true"
         navigate:
         -  SUCCESS: SUCCESS
         -  FAILURE: loop
   outputs:
   -  return_code
   -  failure_message
   results:
   - FAILURE
   - SUCCESS
