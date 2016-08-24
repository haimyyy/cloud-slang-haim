####################################################
#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description:                 - Retrieve information about a virtual machine.
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
#! @input virtual_machine:       - Primary Virtual Machine identifier. Inventorypath (Datacenter/vm/Folder/MyVM), Name of VM,
#!                                  IP (IPv4 or IPv6 depending upon ESX version), hostname (full), UUID, or the VM id (vm-123,123).
#! @input vm_identifier_type:    - Virtual machine identifier type
#!                                 Valid values: "inventorypath", "name", "ip", "hostname", "uuid", "vmid"
#! @input vm_datacenter:         - Virtual machine datacenter.
#!                                 Optional
#! @input details:               - Other details that you need to find for the VM as a list separated by ",". If the
#!                                  details could not be found (for example ipAddress can not be found if vm is powered
#!                                  off) the details will be "". The details are case sensitive.
#!                                 Valid Values: "config.annotation,config.guestId,config.uuid,config.template,datastore,disabledMethod,guestHeartbeatStatus,guest.guestState,guest.guestId,guest.hostName,guest.ipAddress,guest.toolsVersion,guest.toolsStatus,guest.toolsVersion,overallStatus,runtime.powerState"
#!                                 For more values check the VirtualMachine topic from http://vijava.sourceforge.net/vSphereAPIDoc/ver51/ReferenceGuide/
#!                                 Optional
#! @input connection_timeout:    - The time to wait for a connection to be established, in seconds. A "connectionTimeout"
#!                                  value of '0' represents an infinite timeout.
#!                                 Default value: 0
#!                                 Format: an integer representing seconds
#!                                 Examples: 10, 20
#! @input socket_timeout:        - The time to wait for data (a maximum period of inactivity between two consecutive data
#!                                  packets), in seconds. A "socketTimeout" value of '0' represents an infinite timeout.
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
#! @output return_result:           Virtual machine ID (vmid) or reason for failure.
#! @output vm_info:              - JSONObject containing the pairs key:value. The key is from the "details" input field.
#! @output name:                 - Name of the virtual machine.
#! @output uuid:                 - UUID of the virtual machine.
#! @output inventory_path:       - Inventory path of the virtual machine.
#! @output data_store:           - The name of the datastore where the vm configuration file (.vmx) is stored.
#! @output vmx_path:             - The path to the vm configuration file (.vmx) on dataStore.
#! @output return_code:          - The return code of the operation.
#! @result SUCCESS:              - The operation completed successfully. (return_code 0)
#! @result FAILURE:              - Something went wrong.  See return_result for details.(return_code -1)
#! Notes:
#! 1) Depending on the "host" input value, the inventory path can have one of the following formats:
#!     - If "host" is an ESX server, the inventory path will have the format: ha-datacenter/vm/<name of vm>
#!     - If "host" is a vCenter, the inventory path will have the format: <name of datacenter>/vm/<folders>/<name of vm> .
#!      The <folders>/<name of vm> part of the path is based on the "Virtual Machines & Templates" view in the vCenter client.
#! 2) The inventory path is case sensitive.
#!!#
####################################################
namespace: io.cloudslang.vmware.vm
operation: 
   name: get_vm
   inputs: 
   -  host: 
         private: false
         sensitive: false
         required: true
   -  user: 
         private: false
         sensitive: false
         required: false
   -  password: 
         private: false
         sensitive: true
         required: true
   -  port:
         default: "443"
         private: false
         sensitive: false
         required: true
   -  protocol:
         default: "https"
         private: false
         sensitive: false
         required: true
   -  close_session:
         default: "true"
         private: false
         sensitive: false
         required: true
   -  closeSession: 
         private: true
         default: ${get("close_session", "")}
         sensitive: false
         required: false
   -  vm_identifier_type: 
         private: false
         sensitive: false
         required: true
   -  vmIdentifierType: 
         private: true
         default: ${get("vm_identifier_type", "")}
         sensitive: false
         required: false
   -  virtual_machine: 
         private: false
         sensitive: false
         required: true
   -  virtualMachine: 
         private: true
         default: ${get("virtual_machine", "")}
         sensitive: false
         required: false
   -  vm_datacenter:
         required: false
   -  vmDatacenter:
         private: true
         default: ${get("vm_datacenter", "")}
         sensitive: false
         required: false
   -  details:
         required: false
   -  connection_timeout:
         default: "0"
         private: false
         sensitive: false
         required: false
   -  connectionTimeout: 
         private: true
         default: ${get("connection_timeout", "")}
         sensitive: false
         required: false
   -  socket_timeout:
         default: "0"
         private: false
         sensitive: false
         required: false
   -  socketTimeout: 
         private: true
         default: ${get("socket_timeout", "")}
         sensitive: false
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
      class_name: io.cloudslang.content.actions.vmware.vm.GetVM
   outputs: 
   -  inventory_path: ${get("inventoryPath", "")}
   -  return_code: ${returnCode}
   -  vmx_path: ${get("vmxPath", "")}
   -  return_result: ${returnResult}
   -  name
   -  data_store: ${get("dataStore", "")}
   -  vm_info: ${get("vmInfo", "")}
   -  uuid
   -  vm_id: ${get("vmId", "")}
   results:
   -  SUCCESS: ${returnCode=='0'}
   -  FAILURE: ${returnCode=='-1'}
