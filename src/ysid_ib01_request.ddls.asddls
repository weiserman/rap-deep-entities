@EndUserText.label: 'request'
define root abstract entity ysid_ib01_request {
    d   : abap.char(10);
    coco : composition[0..*] of ysid_ib01_coco;
    plant : composition[0..*] of ysid_ib01_plant;
}
