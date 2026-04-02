@EndUserText.label: 'plant'
define abstract entity ysid_ib01_plant {
    sign   : abap.char(1);
    opt    : abap.char(2);
    low    : abap.char(4);
    _parent : association to parent ysid_ib01_request;
}
