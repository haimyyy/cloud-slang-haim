####################################################
#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description:                 - Clones a virtual machine. The virtual machine may be a template vm. The source
#!                                  virtual machine is specified via vmIdentifierType and virtualMachine
#!                                  (optionally vm_datacenter) while the clone is defined by vmName,vmFolder,
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
#! @input virtual_machine:       - Primary Virtual Machine identifier of the virtual machine to clone from.
#!                                  Inventorypath (Datacenter/vm/Folder/MyVM), Name of VM, IP (IPv4 or IPv6
#!                                  depending upon ESX version), hostname (full), UUID, or the VM id (vm-123,123).
#! @input vm_datacenter:         - Virtual machine's datacenter. If host is ESX(i) use "ha-datacenter".
#! @input vm_name:               - Name of new virtual machine being created.
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
namespace: io.cloudslang.vmware.vm
operation: 
   name: clone_vm
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
         private: false
         sensitive: false
         required: true
   -  vmDatacenter: 
         private: true
         default: ${get("vm_datacenter", "")}
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
   -  data_store: 
         private: false
         sensitive: false
         required: false
   -  dataStore: 
         private: true
         default: ${get("data_store", "")}
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
   -  mark_as_template: 
         private: false
         sensitive: false
         required: true
   -  markAsTemplate: 
         private: true
         default: ${get("mark_as_template", "")}
         sensitive: false
         required: false
   -  thin_provision: 
         private: false
         sensitive: false
         required: false
   -  thinProvision: 
         private: true
         default: ${get("thin_provision", "")}
         sensitive: false
         required: false
   -  customization_template_name: 
         private: false
         sensitive: false
         required: false
   -  customizationTemplateName: 
         private: true
         default: ${get("customization_template_name", "")}
         sensitive: false
         required: false
   -  customization_spec_xml: 
         private: false
         sensitive: false
         required: false
   -  customizationSpecXml: 
         private: true
         default: ${get("customization_spec_xml", "")}
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
      class_name: io.cloudslang.content.actions.vmware.vm.CloneVM
   outputs: 
   -  return_code: ${returnCode}
   -  return_result: ${returnResult}
   -  vm_id: ${get("vmId")}
   -  inventory_path: ${get("inventoryPath")}
   results:
   -  SUCCESS: ${returnCode=='0'}
   -  FAILURE: ${returnCode=='-1'}
