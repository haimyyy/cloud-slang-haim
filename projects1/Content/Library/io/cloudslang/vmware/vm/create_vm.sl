####################################################
#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description:                 - Creates a new virtual machine in the vmFolder specified and attaches it to the resource pool specified. Required privilege for the user that runs
#!                                  this operation: VirtualMachine.Inventory.Create
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
#! @input vm_name:               - Virtual machine name being created (new).
#! @input vm_cpu_count:          - Number of virtual machine CPUs to setup.
#! @input host_system:           - Target virtual machine host system.
#! @input cluster_name:          - Name of the VMWare HA or DRS cluster.
#! @input description:           - Description / annotation.
#! @input data_store:            - Datastore or datastore cluster (eg. host:dsname, mydatastore).
#! @input guest_osid:            - Guest OS ID (eg. win95Guest,winNetEnterprise64Guest,etc.) or OS description (Microsoft Windows 3.1,Microsoft Windows Vista (64-bit),
#!                                  Red Hat Enterprise Linux 3 (64-bit)). A list of valid entries can be retrieved via the GetOSDescriptors operation.
#! @input vm_datacenter:         - Virtual machine's datacenter.
#! @input vm_memory_size:        - Virtual machine memory size (megabytes).
#!                                 Default: 512
#! @input vm_resource_pool:      - Virtual machine's resource pool.
#! @input vm_folder:             - Virtual machine's folder by inventory path, '/' delimited not including datacenter
#!                               - Example: "ManagedVMs/DRS/Location1". For root folder, use '/'.
#! @input vm_disk_size:          - Size of the virtual disk to create (MB).
#! @input thin_provision:        - Specify whether to perform thin provisioning of the virtual disk. If true, the disk format will be set as thin provisioned format.
#!                                  If false, the disk format will be set as thick format
#!                                 Valid values: "true", "false"
#!                                 Default Value: "false"
#! @input eager_zero:            - Specify if the thick disk type (thinProvisioning input set to false) is eager zero or lazy zeroed. Data located on eager zeroed
#!                                  disks is zeroed out when the virtual disk is created. It migth take longer to create disks in this format
#!                                 Valid values: "true", "false"
#!                                 Default Value: "false"
#! @input network_name:          - Name of the virtual machine's network or network port group. The value is case sensitive. If the input is empty, the virtual machine
#!                                  will be added to the first network found.
#! @input version:               - The hardware version of the virtual machine. If the input is empty, VMware will assign a version to the VM based on the version of the
#!                                  ESX it is created on
#!                                 Valid values: "vmx-04", "vmx-07", "vmx-08", "vmx-09", "vmx-10", "vmx-11"
#! @input bus_sharing:           - Mode for sharing the SCSI bus
#!                                 Valid values: "physical", "virtual", "none".
#! @input controller_type:       - The SCSI controller type
#!                                 Valid values: "BusLogic Parallel", "LSI Logic Parallel","LSI Logic SAS","VMware Paravirtual".
#! @input connection_timeout:    - The time to wait for a connection to be established, in seconds. A "connectionTimeout" value of '0' represents an infinite timeout
#!                                 Default value: 0
#!                                 Format: an integer representing seconds
#!                                 Examples: 10, 20
#! @input socket_timeout:        - The time to wait for data (a maximum period of inactivity between two consecutive data packets), in seconds. A "socketTimeout" value
#!                                  of '0' represents an infinite timeout
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
#! @output return_code:          - The return code of the operation. (0,-1)
#! @output vm_id:                - The ID of the new vm in case of SUCCESS.
#! @output inventory_path:       - The inventory path of the new vm in case of SUCCESS. The path is build regarding the
#!                                  "host" input value. Read Inventory Path Formatting for more details.
#! @result SUCCESS:              - The operation completed successfully. (return_code 0)
#! @result FAILURE:              - Something went wrong. (return_code -1)
#! Notes:
#! 1. Note that "socketTimeout" and "connectionTimeout" inputs do not represent the time to wait for the operation to complete.
#!                                They are used when communicating with the service, to make sure that the service is up and
#!                                responds to client's requests. They can be used for service diagnosis purpose.
#! 2. The "taskTimeOut" input is only used when the task is performed in a synchronous manner ("async" is set to "false").
#! 3. There are some limitations based on the VM hardware version:
#!                                Virtual hardware 11 (vSphere 6.0): 128 CPU,4TB RAM, 62TB HDD
#!                                Virtual hardware 10 (vSphere 5.5): 64 CPU, 1TB RAM, 62TB HDD
#!                                Virtual hardware 9 (vSphere 5.1): 64 CPU, 1TB RAM, 2TB HDD
#!                                Virtual hardware 8 (vSphere 5): 32 CPU, 1TB RAM, 2TB HDD
#!                                Virtual hardware 7 (vSphere 4): 8 CPU, 256GB RAM, 2TB HDD
#!                                Virtual hardware 4 (ESX 3.x): 4 CPU, 64GB RAM, 2TB HDD
#!                                Virtual hardware 3 (ESX 2.5): 2 CPU, 3600MB RAM, 2TB HDD
#! 4. You must provide a value for either the clusterName or the hostSystem input, they are mutually exclusive.
#!!#
####################################################
namespace: io.cloudslang.vmware.vm
operation: 
   name: create_vm
   inputs: 
   -  host: 
         private: false
         sensitive: false
         required: true
   -  user: 
         private: false
         sensitive: false
         required: true
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
   -  async:
         default: "false"
         private: false
         sensitive: false
         required: true
   -  task_time_out:
         default: "800"
         private: false
         sensitive: false
         required: false
   -  taskTimeOut: 
         private: true
         default: ${get("task_time_out", "")}
         sensitive: false
         required: false
   -  vm_name: 
         private: false
         sensitive: false
         required: true
   -  vmName: 
         private: true
         default: ${get("vm_name", "")}
         sensitive: false
         required: false
   -  vm_cpu_count: 
         private: false
         sensitive: false
         required: true
   -  vmCpuCount: 
         private: true
         default: ${get("vm_cpu_count", "")}
         sensitive: false
         required: false
   -  vm_datacenter: 
         private: false
         sensitive: false
         required: true
   -  vmDatacenter: 
         private: true
         default: ${get("vm_datacenter", "")}
         sensitive: false
         required: false
   -  host_system: 
         private: false
         sensitive: false
         required: false
   -  hostSystem: 
         private: true
         default: ${get("host_system", "")}
         sensitive: false
         required: false
   -  cluster_name: 
         private: false
         sensitive: false
         required: false
   -  clusterName: 
         private: true
         default: ${get("cluster_name", "")}
         sensitive: false
         required: false
   -  description: 
         private: false
         sensitive: false
         required: false
   -  data_store: 
         private: false
         sensitive: false
         required: true
   -  dataStore: 
         private: true
         default: ${get("data_store", "")}
         sensitive: false
         required: false
   -  guest_osid: 
         private: false
         sensitive: false
         required: true
   -  guestOSID: 
         private: true
         default: ${get("guest_osid", "")}
         sensitive: false
         required: false
   -  vm_memory_size:
         default: "512"
         private: false
         sensitive: false
         required: true
   -  vmMemorySize: 
         private: true
         default: ${get("vm_memory_size", "")}
         sensitive: false
         required: false
   -  vm_folder: 
         private: false
         sensitive: false
         required: true
   -  vmFolder: 
         private: true
         default: ${get("vm_folder", "")}
         sensitive: false
         required: false
   -  vm_resource_pool: 
         private: false
         sensitive: false
         required: false
   -  vmResourcePool: 
         private: true
         default: ${get("vm_resource_pool", "")}
         sensitive: false
         required: false
   -  vm_disk_size: 
         private: false
         sensitive: false
         required: true
   -  vmDiskSize: 
         private: true
         default: ${get("vm_disk_size", "")}
         sensitive: false
         required: false
   -  thin_provision:
         default: "false"
         private: false
         sensitive: false
         required: false
   -  thinProvision: 
         private: true
         default: ${get("thin_provision", "")}
         sensitive: false
         required: false
   -  eager_zero:
         default: "false"
         private: false
         sensitive: false
         required: false
   -  eagerZero: 
         private: true
         default: ${get("eager_zero", "")}
         sensitive: false
         required: false
   -  network_name: 
         private: false
         sensitive: false
         required: false
   -  networkName: 
         private: true
         default: ${get("network_name", "")}
         sensitive: false
         required: false
   -  version: 
         private: false
         sensitive: false
         required: false
   -  bus_sharing: 
         private: false
         sensitive: false
         required: false
   -  busSharing: 
         private: true
         default: ${get("bus_sharing", "")}
         sensitive: false
         required: false
   -  controller_type: 
         private: false
         sensitive: false
         required: false
   -  controllerType: 
         private: true
         default: ${get("controller_type", "")}
         sensitive: false
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
         private: "8443"
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
      class_name: io.cloudslang.content.actions.vmware.vm.CreateVM
   outputs: 
   -  return_code: ${returnCode}
   -  return_result: ${returnResult}
   -  vm_id: ${get("vmId")}
   -  inventory_path: ${get("inventoryPath")}
   results: 
   -  SUCCESS: ${returnCode=='0'}
   -  FAILURE: ${returnCode=='-1'}
