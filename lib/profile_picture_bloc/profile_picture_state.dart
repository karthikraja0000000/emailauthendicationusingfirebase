part of 'profile_picture_bloc.dart';


abstract class ProfilePictureState {}

final class ProfilePictureInitial extends ProfilePictureState {}

final class ProfilePictureLoading extends ProfilePictureState{}

final class ProfilePictureLoaded extends ProfilePictureState{

  final String imageURl;
  ProfilePictureLoaded({required this.imageURl});

}

final class ProfilePictureError extends ProfilePictureState{

  final String error;
  ProfilePictureError({required this.error});

}