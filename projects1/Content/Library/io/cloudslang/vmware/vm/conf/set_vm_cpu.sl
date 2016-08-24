####################################################
#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description:                 - Sets a VM cpu count preserving its power state.
#! @input host:                  - VMWare host hostname or IP.
#! @input user:                  - VMWare username.
#!                                 Optional
#! @input password:              - VMWare user's password.
#! @input port:                  - Port to connect on.
#!                                 Default: 443
#! @input protocol:              - Connection protocol
#!                                 Valid values: "https", "http"
#!                                 Default: https
#! @input virtual_machine:       - Primary Virtual Machine identifier. Inventorypath (Datacenter/vm/Folder/MyVM), Name
#!                                  of VM, IP (IPv4 or IPv6 depending upon ESX version), hostname (full), UUID, or the
#!                                  VM id (vm-123,123).
#! @input vm_identifier_type:    - Virtual machine identifier type
#!                                 Valid values: "inventorypath", "name", "ip", "hostname", "uuid", "vmid"
#! @input async:                 - Asynchronously perform the task
#!                                 Valid values: "true", "false"
#!                                 Default: "false"
#! @input task_time_out:         - Time to wait before the operation is considered to have failed (seconds).
#!                                 Default: 800
#! @input vm_datacenter:         - Datacenter of the VM.
#! @input cpu_provision_type:    - Type of provision. If set to no_provision the vm cpu won't be changed and the value
#!                                  from new_cpu_count will be ignored, if set to provision the vm cpu will be set to
#!                                  new_cpu_count, if set to flexup the cpu will be the current cpu count+new_cpu_count,
#!                                  if set to flexdown the cpu will be set to current cpu count - new_cpu_count
#!                                 Valid values: no_provision, provision, flexup, flexdown
#!                                 Default value: provision
#! @input new_cpu_count:         - The new count of CPU or the amount of cpu to add/remove.
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
#! @output return_result:        - This is the primary output. Descriptive result of the operation. Reason for error
#!                                  on failure.
#! @output return_code:          - The return code of the operation. (0,-1)
#! @output failure_message:      - Reason for error on failure.
#! @result SUCCESS:              - The operation completed successfully. (return_code 0)
#! @result FAILURE:              - An exception occured (return_code -1)
#!!#
####################################################
namespace: io.cloudslang.vmware.vm.conf
imports:
   strings: io.cloudslang.base.strings
   math: io.cloudslang.base.math
   power: io.cloudslang.vmware.power
   conf: io.cloudslang.vmware.vm.conf
   subflows: io.cloudslang.vmware.actions.subflows
flow:
   name: set_vm_cpu
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
   -  cpu_provision_type:
         default: "provision"
   -  new_cpu_count
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
   -  check_is_required_cpu_provision:
         do:
            strings.string_equals:
            -  first_string: ${cpu_provision_type}
            -  second_string: "no_provision"
            -  ignore_case: "true"
         publish:
            -  return_code: "0"
            -  failure_message: ''
         navigate:
         -  SUCCESS: SUCCESS
         -  FAILURE: get_current_cpu_count
   -  get_current_cpu_count:
         do:
            conf.get_vm_cpu_count:
            -  host
            -  user
            -  password
            -  port
            -  protocol
            -  vm_identifier_type
            -  virtual_machine
            -  vm_datacenter
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
            -  initial_vm_cpu_count: ${vm_cpu_count if return_code=='0' else ''}
         navigate:
         -  SUCCESS: compute_cpu_provision
         -  FAILURE: FAILURE
   -  compute_cpu_provision:
         do:
            subflows.compute_provision:
            -  current_amount: ${initial_vm_cpu_count}
            -  provision_type: ${cpu_provision_type}
            -  provision_amount: ${new_cpu_count}
         publish:
            -  return_code
            -  failure_message
            -  final_cpu: ${computed_amount if return_code=='0' else ''}
         navigate:
         -  SUCCESS: get_current_power_state
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
            -  initial_power_state: ${return_result if return_code=='0' else ''}
         navigate:
         -  SUCCESS: stop_vm
         -  FAILURE: FAILURE
   -  stop_vm:
         do:
            power.set_power:
            -  host
            -  user
            -  password
            -  port
            -  protocol
            -  vm_identifier_type
            -  virtual_machine
            -  vm_power_state: "poweredOff"
            -  async
            -  task_time_out
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
         -  SUCCESS: set_cpu_count
         -  FAILURE: FAILURE
   -  set_cpu_count:
         do:
            conf.set_vmcpu_count:
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
            -  vm_cpu_count: ${final_cpu}
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
         -  SUCCESS: check_vm_starts
         -  FAILURE: preserve_initial_power_state_failure
   -  check_vm_starts:
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
            -  vm_power_state: "poweredOn"
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
            -  return_code: ${'0' if return_code=='0' else '-1'}
         navigate:
         -  SUCCESS: preserve_initial_power_state_success
         -  NO_ACTION: preserve_initial_cpu
         -  FAILURE: preserve_initial_cpu
   -  preserve_initial_power_state_success:
         do:
            power.set_power:
            -  host
            -  user
            -  password
            -  port
            -  protocol
            -  vm_identifier_type
            -  virtual_machine
            -  vm_power_state: ${initial_power_state}
            -  async
            -  task_time_out
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
         -  SUCCESS: SUCCESS
         -  FAILURE: FAILURE
   -  preserve_initial_cpu:
         do:
            conf.set_vmcpu_count:
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
            -  vm_cpu_count: ${initial_vm_cpu_count}
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
         -  SUCCESS: preserve_initial_power_state_failure
         -  FAILURE: preserve_initial_power_state_failure
   -  preserve_initial_power_state_failure:
         do:
            power.set_power:
            -  host
            -  user
            -  password
            -  port
            -  protocol
            -  vm_identifier_type
            -  virtual_machine
            -  vm_power_state: ${initial_power_state}
            -  async
            -  task_time_out
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
            -  return_code: "-1"
            -  failure_message: "Unable to set cpu."
         navigate:
         -  SUCCESS: FAILURE
         -  FAILURE: FAILURE
   outputs:
   -  return_code
   -  failure_message
   -  return_result: ${failure_message if return_code!='0' else 'Successfully set the vm cpu count.'}
   results:
   - FAILURE
   - SUCCESS
