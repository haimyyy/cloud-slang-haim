####################################################
#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description:                 - Creates a new inventory folder in a Datacenter as seen in vCenter "Inventory > VMs
#!                                  and Templates" view if it doesn't alreay exist.
#! @input host:                  - VMWare host hostname or IP.
#! @input user:                  - VMWare username.
#!                                 Optional
#! @input password:              - VMWare user's password.
#! @input port:                  - Port to connect on.
#!                                 Default: 443
#! @input protocol:              - Connection protocol
#!                                 Valid values: "https", "http"
#!                                 Default: https
#! @input vm_datacenter:         - Datacenter to create new VM inventory folder in.
#! @input vm_folder:             - Path of VM inventory folder to create.  Folder names are delimited by a forward slash
#!                                  "/". Will create any parent folders if they do not already exist.  This input is
#!                                  case sensitive.
#!                                 Example: /Hewlett Packard Enterprise/Operations Orchestration/Templates
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
#! @output folder_id:            - The ID of the created folder.
#! @output failure_message:      - Reason for error on failure.
#! @result SUCCESS:              - The operation completed successfully. (return_code 0)
#! @result FAILURE:              - An exception occured (return_code -1)
#!!#
####################################################
namespace: io.cloudslang.vmware.vm
imports:
   strings: io.cloudslang.base.strings
   math: io.cloudslang.base.math
   utils: io.cloudslang.base.utils
   guest: io.cloudslang.vmware.guest
   power: io.cloudslang.vmware.power
   vm: io.cloudslang.vmware.vm
   actions: io.cloudslang.vmware.actions
flow:
   name: create_vm_folder_if_inexistent
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
   -  vm_datacenter
   -  vm_folder
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
   -  check_vm_folder_exist:
         do:
            vm.check_vm_folder_exist:
            -  host
            -  user
            -  password
            -  port
            -  protocol
            -  vm_datacenter
            -  vm_folder
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
            -  return_code: ${'-1' if return_code=='-1' else '0'}
            -  return_result
            -  folder_id
            -  failure_message: ${return_result if return_code=='-1' else ''}
         navigate:
         -  FOLDER_EXISTS: SUCCESS
         -  FOLDER_DOES_NOT_EXIST: create_vm_folder
         -  FAILURE: FAILURE
   -  create_vm_folder:
         do:
            vm.create_vm_folder:
            -  host
            -  user
            -  password
            -  port
            -  protocol
            -  vm_datacenter
            -  vm_folder
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
            -  return_result
            -  folder_id
            -  failure_message: ${return_result if return_code=='-1' else ''}
         navigate:
         -  SUCCESS: SUCCESS
         -  FAILURE: FAILURE
   outputs:
   -  return_code
   -  folder_id
   -  return_result
   -  failure_message
   results:
   - FAILURE
   - SUCCESS
