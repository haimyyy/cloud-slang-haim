namespace: io.cloudslang.vmware.actions.subflows
imports:
   strings: io.cloudslang.base.strings
   math: io.cloudslang.base.math
   utils: io.cloudslang.base.utils
flow:
   name: compute_provision
   inputs:
   -  current_amount
   -  provision_type
   -  provision_amount
   workflow:
   -  check_is_required_any_provision:
         do:
            strings.string_equals:
            -  first_string: ${provision_type}
            -  second_string: "no_provision"
            -  ignore_case: "true"
         publish:
            -  return_code: "0"
            -  computed_amount: "-1"
         navigate:
         -  SUCCESS: SUCCESS
         -  FAILURE: check_is_required_provision
   -  check_is_required_provision:
         do:
            strings.string_equals:
            -  first_string: ${provision_type}
            -  second_string: "provision"
            -  ignore_case: "true"
            -  provision_amount
         publish:
            -  return_code: "0"
            -  computed_amount: ${provision_amount}
         navigate:
         -  SUCCESS: SUCCESS
         -  FAILURE: check_is_required_flexup
   -  check_is_required_flexup:
         do:
            strings.string_equals:
            -  first_string: ${provision_type}
            -  second_string: "flexup"
            -  ignore_case: "true"
         navigate:
         -  SUCCESS: compute_flexup
         -  FAILURE: check_is_required_flexdown
   -  compute_flexup:
         do:
            math.add_numbers:
            -  value1: ${current_amount}
            -  value2: ${provision_amount}
         publish:
            -  return_code: "0"
            -  computed_amount: ${result}
         navigate:
         -  SUCCESS: SUCCESS
         -  FAILURE: failed_compute_flexup
   -  failed_compute_flexup:
         do:
            math.add_numbers:
            -  value1: "1"
            -  value2: "1"
         publish:
            -  return_code: "-1"
            -  failure_message: "Invalid values to compute."
         navigate:
         -  SUCCESS: FAILURE
         -  FAILURE: FAILURE
   -  check_is_required_flexdown:
         do:
            strings.string_equals:
            -  first_string: ${provision_type}
            -  second_string: "flexdown"
            -  ignore_case: "true"
            -  current_amount
         publish:
            -  return_code: "0"
            -  computed_amount: ${current_amount}
         navigate:
         -  SUCCESS: compute_flexdown
         -  FAILURE: invalid_request
   -  compute_flexdown:
         do:
            math.subtract_numbers:
            -  value1: ${current_amount}
            -  value2: ${provision_amount}
         publish:
            -  return_code: "0"
            -  computed_amount: ${result}
         navigate:
         -  SUCCESS: SUCCESS
         -  FAILURE: failed_compute_flexdown
   -  failed_compute_flexdown:
         do:
            math.add_numbers:
            -  value1: "1"
            -  value2: "1"
         publish:
            -  return_code: "-1"
            -  failure_message: "Invalid values to compute."
         navigate:
         -  SUCCESS: FAILURE
         -  FAILURE: FAILURE
   -  invalid_request:
         do:
            math.add_numbers:
            -  value1: "1"
            -  value2: "1"
         publish:
            -  return_code: "-1"
            -  failure_message: "Invalid provision type. Valid values are: flexup, flexdown, provision, no_provision."
         navigate:
         -  SUCCESS: FAILURE
         -  FAILURE: FAILURE
   outputs:
   -  return_code
   -  failure_message
   -  return_result: ${failure_message if return_code!='0' else 'Provisioned with success'}
   -  computed_amount
   results:
   - FAILURE
   - SUCCESS
