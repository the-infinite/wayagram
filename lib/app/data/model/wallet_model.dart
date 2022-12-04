import 'dart:convert';
/// id : 4358327
/// del_flg : false
/// entity_cre_flg : true
/// sol_id : "0000"
/// bacid : ""
/// accountNo : "2015428438"
/// nubanAccountNo : "0"
/// acct_name : "CEPHAS AROWOLO"
/// gl_code : "21200"
/// product_code : "SB601"
/// acct_ownership : "C"
/// frez_code : null
/// frez_reason_code : null
/// acct_opn_date : "2022-11-26"
/// acct_cls_flg : false
/// clr_bal_amt : 0.0
/// un_clr_bal_amt : 0.0
/// hashed_no : "NjM5fDIwMTU0Mjg0Mzh8U0I2MDF8TkdO"
/// int_paid_flg : true
/// int_coll_flg : false
/// lchg_user_id : null
/// lchg_time : null
/// rcre_user_id : "WAYADMIN"
/// rcre_time : "2022-11-26"
/// acct_crncy_code : "NGN"
/// lien_amt : 0.0
/// product_type : "SBA"
/// cum_dr_amt : 0.0
/// cum_cr_amt : 0.0
/// chq_alwd_flg : false
/// cash_dr_limit : 9.99999999999E9
/// xfer_dr_limit : 9.99999999999E9
/// cash_cr_limit : 9.99999999999E9
/// xfer_cr_limit : 9.99999999999E9
/// acct_cls_date : null
/// last_tran_date : null
/// last_tran_id_dr : null
/// last_tran_id_cr : null
/// walletDefault : false
/// lien_reason : null
/// accountType : "SAVINGS"
/// description : "TEST_WAYAGRAM"

WalletModel walletModelFromJson(String str) => WalletModel.fromJson(json.decode(str));
String walletModelToJson(WalletModel data) => json.encode(data.toJson());
class WalletModel {
  WalletModel({
      num? id, 
      bool? delFlg, 
      bool? entityCreFlg, 
      String? solId, 
      String? bacid,
      String? accountNo, 
      String? nubanAccountNo, 
      String? acctName, 
      String? glCode, 
      String? productCode, 
      String? acctOwnership, 
      dynamic frezCode, 
      dynamic frezReasonCode, 
      String? acctOpnDate, 
      bool? acctClsFlg, 
      num? clrBalAmt, 
      num? unClrBalAmt, 
      String? hashedNo, 
      bool? intPaidFlg, 
      bool? intCollFlg, 
      dynamic lchgUserId, 
      dynamic lchgTime, 
      String? rcreUserId, 
      String? rcreTime, 
      String? acctCrncyCode, 
      num? lienAmt, 
      String? productType, 
      num? cumDrAmt, 
      num? cumCrAmt, 
      bool? chqAlwdFlg, 
      num? cashDrLimit, 
      num? xferDrLimit, 
      num? cashCrLimit, 
      num? xferCrLimit, 
      dynamic acctClsDate, 
      dynamic lastTranDate, 
      dynamic lastTranIdDr, 
      dynamic lastTranIdCr, 
      bool? walletDefault, 
      dynamic lienReason, 
      String? accountType, 
      String? description,}){
    _id = id;
    _delFlg = delFlg;
    _entityCreFlg = entityCreFlg;
    _solId = solId;
    _bacid = bacid;
    _accountNo = accountNo;
    _nubanAccountNo = nubanAccountNo;
    _acctName = acctName;
    _glCode = glCode;
    _productCode = productCode;
    _acctOwnership = acctOwnership;
    _frezCode = frezCode;
    _frezReasonCode = frezReasonCode;
    _acctOpnDate = acctOpnDate;
    _acctClsFlg = acctClsFlg;
    _clrBalAmt = clrBalAmt;
    _unClrBalAmt = unClrBalAmt;
    _hashedNo = hashedNo;
    _intPaidFlg = intPaidFlg;
    _intCollFlg = intCollFlg;
    _lchgUserId = lchgUserId;
    _lchgTime = lchgTime;
    _rcreUserId = rcreUserId;
    _rcreTime = rcreTime;
    _acctCrncyCode = acctCrncyCode;
    _lienAmt = lienAmt;
    _productType = productType;
    _cumDrAmt = cumDrAmt;
    _cumCrAmt = cumCrAmt;
    _chqAlwdFlg = chqAlwdFlg;
    _cashDrLimit = cashDrLimit;
    _xferDrLimit = xferDrLimit;
    _cashCrLimit = cashCrLimit;
    _xferCrLimit = xferCrLimit;
    _acctClsDate = acctClsDate;
    _lastTranDate = lastTranDate;
    _lastTranIdDr = lastTranIdDr;
    _lastTranIdCr = lastTranIdCr;
    _walletDefault = walletDefault;
    _lienReason = lienReason;
    _accountType = accountType;
    _description = description;
}

  WalletModel.fromJson(dynamic json) {
    _id = json['id'];
    _delFlg = json['del_flg'];
    _entityCreFlg = json['entity_cre_flg'];
    _solId = json['sol_id'];
    _bacid = json['bacid'];
    _accountNo = json['accountNo'];
    _nubanAccountNo = json['nubanAccountNo'];
    _acctName = json['acct_name'];
    _glCode = json['gl_code'];
    _productCode = json['product_code'];
    _acctOwnership = json['acct_ownership'];
    _frezCode = json['frez_code'];
    _frezReasonCode = json['frez_reason_code'];
    _acctOpnDate = json['acct_opn_date'];
    _acctClsFlg = json['acct_cls_flg'];
    _clrBalAmt = json['clr_bal_amt'];
    _unClrBalAmt = json['un_clr_bal_amt'];
    _hashedNo = json['hashed_no'];
    _intPaidFlg = json['int_paid_flg'];
    _intCollFlg = json['int_coll_flg'];
    _lchgUserId = json['lchg_user_id'];
    _lchgTime = json['lchg_time'];
    _rcreUserId = json['rcre_user_id'];
    _rcreTime = json['rcre_time'];
    _acctCrncyCode = json['acct_crncy_code'];
    _lienAmt = json['lien_amt'];
    _productType = json['product_type'];
    _cumDrAmt = json['cum_dr_amt'];
    _cumCrAmt = json['cum_cr_amt'];
    _chqAlwdFlg = json['chq_alwd_flg'];
    _cashDrLimit = json['cash_dr_limit'];
    _xferDrLimit = json['xfer_dr_limit'];
    _cashCrLimit = json['cash_cr_limit'];
    _xferCrLimit = json['xfer_cr_limit'];
    _acctClsDate = json['acct_cls_date'];
    _lastTranDate = json['last_tran_date'];
    _lastTranIdDr = json['last_tran_id_dr'];
    _lastTranIdCr = json['last_tran_id_cr'];
    _walletDefault = json['walletDefault'];
    _lienReason = json['lien_reason'];
    _accountType = json['accountType'];
    _description = json['description'];
  }
  num? _id;
  bool? _delFlg;
  bool? _entityCreFlg;
  String? _solId;
  String? _bacid;
  String? _accountNo;
  String? _nubanAccountNo;
  String? _acctName;
  String? _glCode;
  String? _productCode;
  String? _acctOwnership;
  dynamic _frezCode;
  dynamic _frezReasonCode;
  String? _acctOpnDate;
  bool? _acctClsFlg;
  num? _clrBalAmt;
  num? _unClrBalAmt;
  String? _hashedNo;
  bool? _intPaidFlg;
  bool? _intCollFlg;
  dynamic _lchgUserId;
  dynamic _lchgTime;
  String? _rcreUserId;
  String? _rcreTime;
  String? _acctCrncyCode;
  num? _lienAmt;
  String? _productType;
  num? _cumDrAmt;
  num? _cumCrAmt;
  bool? _chqAlwdFlg;
  num? _cashDrLimit;
  num? _xferDrLimit;
  num? _cashCrLimit;
  num? _xferCrLimit;
  dynamic _acctClsDate;
  dynamic _lastTranDate;
  dynamic _lastTranIdDr;
  dynamic _lastTranIdCr;
  bool? _walletDefault;
  dynamic _lienReason;
  String? _accountType;
  String? _description;
WalletModel copyWith({  num? id,
  bool? delFlg,
  bool? entityCreFlg,
  String? solId,
  String? bacid,
  String? accountNo,
  String? nubanAccountNo,
  String? acctName,
  String? glCode,
  String? productCode,
  String? acctOwnership,
  dynamic frezCode,
  dynamic frezReasonCode,
  String? acctOpnDate,
  bool? acctClsFlg,
  num? clrBalAmt,
  num? unClrBalAmt,
  String? hashedNo,
  bool? intPaidFlg,
  bool? intCollFlg,
  dynamic lchgUserId,
  dynamic lchgTime,
  String? rcreUserId,
  String? rcreTime,
  String? acctCrncyCode,
  num? lienAmt,
  String? productType,
  num? cumDrAmt,
  num? cumCrAmt,
  bool? chqAlwdFlg,
  num? cashDrLimit,
  num? xferDrLimit,
  num? cashCrLimit,
  num? xferCrLimit,
  dynamic acctClsDate,
  dynamic lastTranDate,
  dynamic lastTranIdDr,
  dynamic lastTranIdCr,
  bool? walletDefault,
  dynamic lienReason,
  String? accountType,
  String? description,
}) => WalletModel(  id: id ?? _id,
  delFlg: delFlg ?? _delFlg,
  entityCreFlg: entityCreFlg ?? _entityCreFlg,
  solId: solId ?? _solId,
  bacid: bacid ?? _bacid,
  accountNo: accountNo ?? _accountNo,
  nubanAccountNo: nubanAccountNo ?? _nubanAccountNo,
  acctName: acctName ?? _acctName,
  glCode: glCode ?? _glCode,
  productCode: productCode ?? _productCode,
  acctOwnership: acctOwnership ?? _acctOwnership,
  frezCode: frezCode ?? _frezCode,
  frezReasonCode: frezReasonCode ?? _frezReasonCode,
  acctOpnDate: acctOpnDate ?? _acctOpnDate,
  acctClsFlg: acctClsFlg ?? _acctClsFlg,
  clrBalAmt: clrBalAmt ?? _clrBalAmt,
  unClrBalAmt: unClrBalAmt ?? _unClrBalAmt,
  hashedNo: hashedNo ?? _hashedNo,
  intPaidFlg: intPaidFlg ?? _intPaidFlg,
  intCollFlg: intCollFlg ?? _intCollFlg,
  lchgUserId: lchgUserId ?? _lchgUserId,
  lchgTime: lchgTime ?? _lchgTime,
  rcreUserId: rcreUserId ?? _rcreUserId,
  rcreTime: rcreTime ?? _rcreTime,
  acctCrncyCode: acctCrncyCode ?? _acctCrncyCode,
  lienAmt: lienAmt ?? _lienAmt,
  productType: productType ?? _productType,
  cumDrAmt: cumDrAmt ?? _cumDrAmt,
  cumCrAmt: cumCrAmt ?? _cumCrAmt,
  chqAlwdFlg: chqAlwdFlg ?? _chqAlwdFlg,
  cashDrLimit: cashDrLimit ?? _cashDrLimit,
  xferDrLimit: xferDrLimit ?? _xferDrLimit,
  cashCrLimit: cashCrLimit ?? _cashCrLimit,
  xferCrLimit: xferCrLimit ?? _xferCrLimit,
  acctClsDate: acctClsDate ?? _acctClsDate,
  lastTranDate: lastTranDate ?? _lastTranDate,
  lastTranIdDr: lastTranIdDr ?? _lastTranIdDr,
  lastTranIdCr: lastTranIdCr ?? _lastTranIdCr,
  walletDefault: walletDefault ?? _walletDefault,
  lienReason: lienReason ?? _lienReason,
  accountType: accountType ?? _accountType,
  description: description ?? _description,
);
  num? get id => _id;
  bool? get delFlg => _delFlg;
  bool? get entityCreFlg => _entityCreFlg;
  String? get solId => _solId;
  String? get bacid => _bacid;
  String? get accountNo => _accountNo;
  String? get nubanAccountNo => _nubanAccountNo;
  String? get acctName => _acctName;
  String? get glCode => _glCode;
  String? get productCode => _productCode;
  String? get acctOwnership => _acctOwnership;
  dynamic get frezCode => _frezCode;
  dynamic get frezReasonCode => _frezReasonCode;
  String? get acctOpnDate => _acctOpnDate;
  bool? get acctClsFlg => _acctClsFlg;
  num? get clrBalAmt => _clrBalAmt;
  num? get unClrBalAmt => _unClrBalAmt;
  String? get hashedNo => _hashedNo;
  bool? get intPaidFlg => _intPaidFlg;
  bool? get intCollFlg => _intCollFlg;
  dynamic get lchgUserId => _lchgUserId;
  dynamic get lchgTime => _lchgTime;
  String? get rcreUserId => _rcreUserId;
  String? get rcreTime => _rcreTime;
  String? get acctCrncyCode => _acctCrncyCode;
  num? get lienAmt => _lienAmt;
  String? get productType => _productType;
  num? get cumDrAmt => _cumDrAmt;
  num? get cumCrAmt => _cumCrAmt;
  bool? get chqAlwdFlg => _chqAlwdFlg;
  num? get cashDrLimit => _cashDrLimit;
  num? get xferDrLimit => _xferDrLimit;
  num? get cashCrLimit => _cashCrLimit;
  num? get xferCrLimit => _xferCrLimit;
  dynamic get acctClsDate => _acctClsDate;
  dynamic get lastTranDate => _lastTranDate;
  dynamic get lastTranIdDr => _lastTranIdDr;
  dynamic get lastTranIdCr => _lastTranIdCr;
  bool? get walletDefault => _walletDefault;
  dynamic get lienReason => _lienReason;
  String? get accountType => _accountType;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['del_flg'] = _delFlg;
    map['entity_cre_flg'] = _entityCreFlg;
    map['sol_id'] = _solId;
    map['bacid'] = _bacid;
    map['accountNo'] = _accountNo;
    map['nubanAccountNo'] = _nubanAccountNo;
    map['acct_name'] = _acctName;
    map['gl_code'] = _glCode;
    map['product_code'] = _productCode;
    map['acct_ownership'] = _acctOwnership;
    map['frez_code'] = _frezCode;
    map['frez_reason_code'] = _frezReasonCode;
    map['acct_opn_date'] = _acctOpnDate;
    map['acct_cls_flg'] = _acctClsFlg;
    map['clr_bal_amt'] = _clrBalAmt;
    map['un_clr_bal_amt'] = _unClrBalAmt;
    map['hashed_no'] = _hashedNo;
    map['int_paid_flg'] = _intPaidFlg;
    map['int_coll_flg'] = _intCollFlg;
    map['lchg_user_id'] = _lchgUserId;
    map['lchg_time'] = _lchgTime;
    map['rcre_user_id'] = _rcreUserId;
    map['rcre_time'] = _rcreTime;
    map['acct_crncy_code'] = _acctCrncyCode;
    map['lien_amt'] = _lienAmt;
    map['product_type'] = _productType;
    map['cum_dr_amt'] = _cumDrAmt;
    map['cum_cr_amt'] = _cumCrAmt;
    map['chq_alwd_flg'] = _chqAlwdFlg;
    map['cash_dr_limit'] = _cashDrLimit;
    map['xfer_dr_limit'] = _xferDrLimit;
    map['cash_cr_limit'] = _cashCrLimit;
    map['xfer_cr_limit'] = _xferCrLimit;
    map['acct_cls_date'] = _acctClsDate;
    map['last_tran_date'] = _lastTranDate;
    map['last_tran_id_dr'] = _lastTranIdDr;
    map['last_tran_id_cr'] = _lastTranIdCr;
    map['walletDefault'] = _walletDefault;
    map['lien_reason'] = _lienReason;
    map['accountType'] = _accountType;
    map['description'] = _description;
    return map;
  }

  static List<WalletModel> listFromJson(List? list) {
    if (list == null) return [];
    if (list.isEmpty) return [];
    return list.map((item) => WalletModel.fromJson(item)).toList();
  }

}