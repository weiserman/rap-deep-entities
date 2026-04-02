@EndUserText.label: 'fail'
define abstract entity ysid_ib01_fail {
    field : abap.char(30);
    sign  : abap.char(1);
    opt   : abap.char(2);
    low   : abap.char(10);
    _parent : association to parent ysid_ib01_response;
}
