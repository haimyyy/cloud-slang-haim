namespace: io.cloudslang.vmware.guest
operation: 
   name: mount_tools
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
         private: false
         sensitive: false
         required: true
   -  protocol: 
         private: false
         sensitive: false
         required: true
   -  close_session: 
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
   -  auth_type: 
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
         private: false
         sensitive: false
         required: false
   -  trustAllRoots: 
         private: true
         default: ${get("trust_all_roots", "")}
         sensitive: false
         required: false
   -  x_509_hostname_verifier:
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
      class_name: io.cloudslang.content.actions.vmware.guest.MountTools
   outputs: 
   -  return_code: ${returnCode}
   -  ?returnresult: ${?RETURNRESULT}
   results: 
   -  SUCCESS: ${returnCode=='0'}
   -  FAILURE: ${returnCode=='-1'}
