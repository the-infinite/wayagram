
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/quotation/buyer/model/create_request_state_model.dart';
import 'package:wayagram/features/quotation/data/repo/quotation_repository.dart';


class CreateRequestVm extends StateNotifier<CreateRequestState> {
  final QuotationRepository _quotationRepository;

  final _logger = getLogger('CreateRequestVm');

  CreateRequestVm(this._quotationRepository, )
      : super(CreateRequestState());

}