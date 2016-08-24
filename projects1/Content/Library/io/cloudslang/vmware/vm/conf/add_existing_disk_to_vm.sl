####################################################
#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description:                 - Add an existing virtual (SCSI) disk to an existing virtual machine.
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
#! @input async:                 - Asynchronously perform the task
#!                                 Valid values: "true", "false"
#!                                 Default: "false"
#! @input task_time_out:         - Time to wait before the operation is considered to have failed (seconds).
#!                                 Default: 800
#! @input vm_datacenter:         - Virtual machine's datacenter.
#! @input data_store:            - Datastore or data cluster visible from the VM.
#!                               - Examples: host:dsname, mydatastore
#! @input disk_path:             - Path to the .vmdk file on the datastore to use for backing the new virtual disk.
#!                                  Include .vmdk suffix and do NOT include leading / . This path is case sensitive and
#!                                  must already exist on the datastore.
#! @input disk_mode:             - Disk persistence mode.
#!                                 Valid values for ESX 3 and later VMs: persistent, independent_persistent, independent_nonpersistent.
#!                                 Valid values for pre ESX 3 VMs: persistent, nonpersistent, undoable, append.
#! @input disk_scsi_node:        - The SCSI Node where the disk should be attached. If the input is left empty the
#!                                  operation will work in auto select mode.
#!                                 Examples: "0:0", "0:5", "2:1", "2:-1", "1:15"
#! @input controller_type:       - The SCSI controller type used when creating a new controller. If the input is left
#!                                  empty the operation will work in auto select mode.
#!                                 Valid values: "BusLogic Parallel", "LSI Logic Parallel", "LSI Logic SAS", "VMware Paravirtual"
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
#! @output return_code:          - The return code of the operation.
#! @result SUCCESS:              - If async is true the task was successfuly queued.  If async is false the snapshot
#!                                  of the virtual machine was successfuly created. (return_code 0)
#! @result FAILURE:              - Something went wrong.  See return_result for details.(return_code -1)
#! Notes:
#! 1. Inventory Path Formatting: If host is an ESX server inventory path will be: ha-datacenter/vm/<name of vm> .
#!                               If host is a vCenter the inventory path will be: <name of datacenter>/vm/<folders>/<name of vm> .
#!                               The <folders>/<name of vm> part of the path is based on the "Virtual Machines & Templates"
#!                               view in the vCenter client. The inventory path is case sensitive.
#! 2. If a data cluster is provided in the "dataStore" input, the operation will apply a Storage DRS recommendation.
#! 3. The SCSI Node from "disk_scsi_node" represents "SCSI controller (bus) number":"Disk unit number on the controller".
#!                               Valid values for SCSI controller number are: 0,1,2,3 and for disk unit number:
#!                               0,1,2,...,15 without 7 (reserved by WMware).
#! 4. If the "disk_scsi_node" is left empty the first empty space on an existing controller will be used or a new
#!                               controller will be automatically created if a controller number is available. If the
#!                               unit number is set as -1 the operation will find the first empty space on the specified
#!                               controller.
#! 5. If the "controllerType" input is left empy the operation will use the type of the first controller found on VM or
#!                               the "BusLogic Parallel" if the newly created controller is the first one attached to the VM.
#!!#
####################################################
namespace: io.cloudslang.vmware.vm.conf
operation: 
   name: add_existing_disk_to_vm
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
         required: false
   -  vmDatacenter: 
         private: true
         default: ${get("vm_datacenter", "")}
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
   -  disk_path: 
         private: false
         sensitive: false
         required: true
   -  diskPath: 
         private: true
         default: ${get("disk_path", "")}
         sensitive: false
         required: false
   -  disk_mode: 
         private: false
         sensitive: false
         required: true
   -  diskMode: 
         private: true
         default: ${get("disk_mode", "")}
         sensitive: false
         required: false
   -  disk_scsi_node: 
         private: false
         sensitive: false
         required: false
   -  diskSCSINode: 
         private: true
         default: ${get("disk_scsi_node", "")}
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
         private: false
         sensitive: false
         required: false
   -  proxyPort:
         default: "8443"
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
      class_name: io.cloudslang.content.actions.vmware.vm.conf.AddExistingDiskToVM
   outputs: 
   -  return_code: ${returnCode}
   -  return_result: ${returnResult}
   results: 
   -  SUCCESS: ${returnCode=='0'}
   -  FAILURE: ${returnCode=='-1'}
