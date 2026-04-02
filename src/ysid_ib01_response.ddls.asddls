@EndUserText.label: 'response'
define root abstract entity ysid_ib01_response {
    d       : abap.char(10);
    success : composition[0..*] of ysid_ib01_success;
    failure : composition[0..*] of ysid_ib01_fail;
}
