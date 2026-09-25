import 'package:dartz/dartz.dart';
import 'package:stock_control_master/shared/failure.dart' show Failure;
import 'package:equatable/equatable.dart';

///[Future].
mixin UseCases<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

///[Stream].
mixin StreamUseCases<T, Params> {
  Stream<T> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
