@EndUserText.label: 'coco'
define abstract entity ysid_ib01_coco {
    sign   : abap.char(1);
    opt    : abap.char(2);
    low    : abap.char(4);
    _parent : association to parent ysid_ib01_request;
}
