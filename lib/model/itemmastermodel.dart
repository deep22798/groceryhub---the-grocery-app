class ItemMasterModel {
  dynamic clrGroup;
  dynamic? department;
  dynamic? displayGrp;
  dynamic? finalStock;
  dynamic? genname;
  dynamic? gstitmcd;
  dynamic iColor;
  dynamic? iSize;
  dynamic? icompany;
  dynamic? imageFile;
  dynamic? mrp;
  dynamic? material;
  dynamic? plucode;
  dynamic? pPrice;
  dynamic? prersupl;
  dynamic? productGroup;
  dynamic? stkcgstRate;
  dynamic? stkgstRate;
  dynamic? stkhsnCode;
  dynamic? stkigstRate;
  dynamic? stksgstRate;
  dynamic? svrstkid;
  dynamic? salePrice;
  dynamic? type;
  dynamic? units;
  dynamic? units1;
  dynamic? wsPrice;
  dynamic? itmCd;
  dynamic? itmNam;
  dynamic? subgrp;

  ItemMasterModel({
    this.clrGroup,
    this.department,
    this.displayGrp,
    this.finalStock,
    this.genname,
    this.gstitmcd,
    this.iColor,
    this.iSize,
    this.icompany,
    this.imageFile,
    this.mrp,
    this.material,
    this.plucode,
    this.pPrice,
    this.prersupl,
    this.productGroup,
    this.stkcgstRate,
    this.stkgstRate,
    this.stkhsnCode,
    this.stkigstRate,
    this.stksgstRate,
    this.svrstkid,
    this.salePrice,
    this.type,
    this.units,
    this.units1,
    this.wsPrice,
    this.itmCd,
    this.itmNam,
    this.subgrp,
  });

  factory ItemMasterModel.fromJson(Map<dynamic, dynamic> json) => ItemMasterModel(
    clrGroup: json["ClrGroup"],
    department: json["Department"],
    displayGrp: json["DisplayGrp"],
    finalStock: json["FinalStock"],
    genname: json["GENNAME"],
    gstitmcd: json["GSTITMCD"],
    iColor: json["IColor"],
    iSize: json["ISize"],
    icompany: json["Icompany"],
    imageFile: json["ImageFile"],
    mrp: json["MRP"],
    material: json["Material"],
    plucode: json["PLUCODE"],
    pPrice: json["PPrice"],
    prersupl: json["PRERSUPL"],
    productGroup: json["ProductGroup"],
    stkcgstRate: json["STKCGSTRate"],
    stkgstRate: json["STKGSTRate"],
    stkhsnCode: json["STKHSNCode"],
    stkigstRate: json["STKIGSTRate"],
    stksgstRate: json["STKSGSTRate"],
    svrstkid: json["SVRSTKID"],
    salePrice: json["SalePrice"],
    type: json["TYPE"],
    units: json["UNITS"],
    units1: json["UNITS1"],
    wsPrice: json["WSPrice"],
    itmCd: json["itm_CD"],
    itmNam: json["itm_NAM"],
    subgrp: json["subgrp"],
  );

  Map<dynamic, dynamic> toJson() => {
    "ClrGroup": clrGroup,
    "Department": department,
    "DisplayGrp": displayGrp,
    "FinalStock": finalStock,
    "GENNAME": genname,
    "GSTITMCD": gstitmcd,
    "IColor": iColor,
    "ISize": iSize,
    "Icompany": icompany,
    "ImageFile": imageFile,
    "MRP": mrp,
    "Material": material,
    "PLUCODE": plucode,
    "PPrice": pPrice,
    "PRERSUPL": prersupl,
    "ProductGroup": productGroup,
    "STKCGSTRate": stkcgstRate,
    "STKGSTRate": stkgstRate,
    "STKHSNCode": stkhsnCode,
    "STKIGSTRate": stkigstRate,
    "STKSGSTRate": stksgstRate,
    "SVRSTKID": svrstkid,
    "SalePrice": salePrice,
    "TYPE": type,
    "UNITS": units,
    "UNITS1": units1,
    "WSPrice": wsPrice,
    "itm_CD": itmCd,
    "itm_NAM": itmNam,
    "subgrp": subgrp,
  };
}
